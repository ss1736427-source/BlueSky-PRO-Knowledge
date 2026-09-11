param(
    [string]$CodexExecutable,
    [switch]$CheckOnly
)

$ErrorActionPreference = "Stop"

if (-not $CodexExecutable) {
    $repoRoot = Split-Path $PSScriptRoot -Parent | Split-Path -Parent
    $flightPlanningRoot = Split-Path (Split-Path $repoRoot -Parent) -Parent
    $localCodex = Join-Path $flightPlanningRoot "TOOLS\codex\codex.cmd"
    if (Test-Path -LiteralPath $localCodex -PathType Leaf) {
        $CodexExecutable = (Resolve-Path -LiteralPath $localCodex).Path
    }
}

if (-not $CodexExecutable) {
    $codex = Get-Command codex -ErrorAction SilentlyContinue
    if ($codex) { $CodexExecutable = $codex.Source }
}

if (-not $CodexExecutable) {
    Write-Error "Codex executable not found."
    exit 1
}

Write-Host "Codex executable: $CodexExecutable"

function Invoke-CodexCmd {
    param(
        [Parameter(Mandatory=$true)][string[]]$Arguments
    )

    $stdoutFile = [System.IO.Path]::GetTempFileName()
    $stderrFile = [System.IO.Path]::GetTempFileName()
    $batchFile = [System.IO.Path]::GetTempFileName()
    try {
        # Use a temporary .cmd wrapper so Windows cmd.exe performs exactly the
        # same invocation as the proven manual `call "...codex.cmd" ...` form.
        $argumentText = ($Arguments | ForEach-Object {
            if ($_ -match '[\s"]') {
                '"{0}"' -f ($_ -replace '"', '\"')
            } else {
                $_
            }
        }) -join ' '

        $batchContent = "@echo off`r`ncall `"$CodexExecutable`" $argumentText 1>`"$stdoutFile`" 2>`"$stderrFile`"`r`nexit /b %ERRORLEVEL%`r`n"
        Set-Content -LiteralPath $batchFile -Value $batchContent -Encoding ASCII

        $process = Start-Process -FilePath "cmd.exe" `
            -ArgumentList @('/d', '/c', "`"$batchFile`"") `
            -Wait -PassThru -WindowStyle Hidden

        $stdout = ""
        $stderr = ""
        if (Test-Path -LiteralPath $stdoutFile) {
            $value = Get-Content -LiteralPath $stdoutFile -Raw -ErrorAction SilentlyContinue
            if ($null -ne $value) { $stdout = [string]$value }
        }
        if (Test-Path -LiteralPath $stderrFile) {
            $value = Get-Content -LiteralPath $stderrFile -Raw -ErrorAction SilentlyContinue
            if ($null -ne $value) { $stderr = [string]$value }
        }

        return [pscustomobject]@{
            ExitCode = $process.ExitCode
            StdOut = $stdout
            StdErr = $stderr
        }
    } finally {
        Remove-Item -LiteralPath $stdoutFile, $stderrFile, $batchFile -Force -ErrorAction SilentlyContinue
    }
}

$versionResult = Invoke-CodexCmd -Arguments @('--version')
if ($versionResult.ExitCode -ne 0) {
    $detail = @($versionResult.StdErr, $versionResult.StdOut) | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) }
    Write-Error "Codex version check failed (exit $($versionResult.ExitCode)): $($detail -join ' ')"
    exit 1
}
$versionText = @($versionResult.StdOut, $versionResult.StdErr) | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) }
Write-Host "Codex version: $(($versionText -join ' ').Trim())"

$statusResult = Invoke-CodexCmd -Arguments @('login', 'status')
$statusCode = $statusResult.ExitCode
$statusOutput = if ($null -ne $statusResult.StdOut) { ([string]$statusResult.StdOut).Trim() } else { "" }
$statusError = if ($null -ne $statusResult.StdErr) { ([string]$statusResult.StdErr).Trim() } else { "" }

Write-Host "Codex login status exit code: $statusCode"
if ($statusOutput) { Write-Host $statusOutput }
if ($statusError) { Write-Host $statusError }

if ($statusCode -ne 0) {
    Write-Error "Codex login status failed. The Codex CLI authentication check did not succeed."
    exit 1
}

# Prevent a project or shell-level OpenAI API key from silently overriding
# ChatGPT OAuth credentials used by Codex CLI.
$overrideVars = @("OPENAI_API_KEY", "OPENAI_ORG_ID", "OPENAI_PROJECT_ID")
$foundOverride = $false
foreach ($name in $overrideVars) {
    if (Test-Path "Env:$name") {
        Write-Warning "$name is present in the parent environment. Codex may use it instead of the ChatGPT login credential."
        $foundOverride = $true
    }
}

if ($foundOverride) {
    Write-Error "Ambiguous Codex credential source. Remove OPENAI_* credential overrides from the orchestrator environment, then rerun."
    exit 1
}

Write-Host "Codex preflight: PASS"
exit 0
