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
    try {
        $quotedCodex = '"{0}"' -f $CodexExecutable
        $argumentText = ($Arguments -join ' ')
        $cmdArguments = '/d /c call {0} {1} 1>"{2}" 2>"{3}"' -f `
            $quotedCodex, $argumentText, $stdoutFile, $stderrFile

        $process = Start-Process -FilePath "cmd.exe" `
            -ArgumentList $cmdArguments `
            -Wait -PassThru -WindowStyle Hidden

        $stdout = if (Test-Path -LiteralPath $stdoutFile) {
            Get-Content -LiteralPath $stdoutFile -Raw -ErrorAction SilentlyContinue
        } else { "" }
        $stderr = if (Test-Path -LiteralPath $stderrFile) {
            Get-Content -LiteralPath $stderrFile -Raw -ErrorAction SilentlyContinue
        } else { "" }

        return [pscustomobject]@{
            ExitCode = $process.ExitCode
            StdOut = $stdout
            StdErr = $stderr
        }
    } finally {
        Remove-Item -LiteralPath $stdoutFile, $stderrFile -Force -ErrorAction SilentlyContinue
    }
}

$versionResult = Invoke-CodexCmd -Arguments @('--version')
if ($versionResult.ExitCode -ne 0) {
    $detail = ($versionResult.StdErr, $versionResult.StdOut | Where-Object { $_ }) -join ' '
    Write-Error "Codex version check failed (exit $($versionResult.ExitCode)): $detail"
    exit 1
}
$versionText = ($versionResult.StdOut, $versionResult.StdErr | Where-Object { $_ }) -join ' '
Write-Host "Codex version: $($versionText.Trim())"

$statusResult = Invoke-CodexCmd -Arguments @('login', 'status')
$statusCode = $statusResult.ExitCode
$statusOutput = $statusResult.StdOut.Trim()
$statusError = $statusResult.StdErr.Trim()

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
