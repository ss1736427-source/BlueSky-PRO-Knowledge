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

$versionOutput = & $CodexExecutable --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "Codex version check failed: $versionOutput"
    exit 1
}
Write-Host "Codex version: $($versionOutput -join ' ')"

# Windows PowerShell may surface native stderr as a terminating ErrorRecord.
# Run the batch wrapper through cmd.exe and capture both streams to files so
# login status is evaluated solely by the native process exit code.
$statusOutputFile = [System.IO.Path]::GetTempFileName()
$statusErrorFile = [System.IO.Path]::GetTempFileName()
try {
    $quotedCodex = '"{0}"' -f $CodexExecutable
    $cmdArguments = '/d /c {0} login status 1>"{1}" 2>"{2}"' -f $quotedCodex, $statusOutputFile, $statusErrorFile
    $process = Start-Process -FilePath "cmd.exe" -ArgumentList $cmdArguments -Wait -PassThru -WindowStyle Hidden
    $statusCode = $process.ExitCode
    $statusOutput = if (Test-Path -LiteralPath $statusOutputFile) {
        Get-Content -LiteralPath $statusOutputFile -Raw -ErrorAction SilentlyContinue
    } else {
        ""
    }
    $statusError = if (Test-Path -LiteralPath $statusErrorFile) {
        Get-Content -LiteralPath $statusErrorFile -Raw -ErrorAction SilentlyContinue
    } else {
        ""
    }
} finally {
    Remove-Item -LiteralPath $statusOutputFile, $statusErrorFile -Force -ErrorAction SilentlyContinue
}

Write-Host "Codex login status exit code: $statusCode"
if ($statusOutput) {
    Write-Host $statusOutput.TrimEnd()
}
if ($statusError) {
    Write-Host $statusError.TrimEnd()
}

if ($statusCode -ne 0) {
    Write-Error "Codex login status failed. Re-authentication is required before the orchestrator can invoke the agent."
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

if ($CheckOnly) {
    Write-Host "Codex preflight: PASS"
    exit 0
}

Write-Host "Codex preflight: PASS"
exit 0
