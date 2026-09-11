param(
    [string]$AgentExecutable = $env:BS_AGENT_EXECUTABLE,
    [string]$AgentArguments = $env:BS_AGENT_ARGUMENTS
)

$ErrorActionPreference = "Stop"

if (-not $env:BS_CURRENT_SHA) { throw "BS_CURRENT_SHA is not set." }

# If no agent was explicitly configured, discover the supported local
# development agent automatically. A configured executable always wins.
if (-not $AgentExecutable) {
    $copilot = Get-Command copilot -ErrorAction SilentlyContinue
    if ($copilot) {
        $AgentExecutable = $copilot.Source
        Write-Host "Agent auto-detected: GitHub Copilot CLI ($AgentExecutable)"
    }
}

# No executable means the local environment still needs one user decision.
# Return 42 so the orchestrator stops instead of retrying the same condition.
if (-not $AgentExecutable) {
    Write-Host "No supported local development agent found. Install GitHub Copilot CLI or configure BS_AGENT_EXECUTABLE."
    exit 42
}

$repo = if ($env:BS_REPO) { $env:BS_REPO } else { "ss1736427-source/BlueSky-PRO-Knowledge" }
$branch = if ($env:BS_BRANCH) { $env:BS_BRANCH } else { "main" }
$protocol = if ($env:BS_PROTOCOL) { $env:BS_PROTOCOL } else { "00_PROJECT/GITHUB_DEVELOPMENT_PROTOCOL.md" }
$rules = if ($env:BS_WORKING_RULES) { $env:BS_WORKING_RULES } else { "00_PROJECT/BLUE_SKY_PRO_WORKING_RULES.md" }

$prompt = @"
BlueSky PRO development continuation.

Verified repository: $repo
Branch: $branch
Verified HEAD SHA: $($env:BS_CURRENT_SHA)

Read these repository files before acting:
- $protocol
- $rules

Verify local HEAD matches the supplied SHA. Continue only with an unambiguous technical step.
Do not make product or architectural decisions. If one is required, stop and return exit code 42.
Run appropriate tests after changes and do not claim CI success unless it belongs to the exact resulting SHA.
When no user decision is required, return 0. When a user decision is required, return 42.
"@

# GitHub Copilot CLI supports programmatic execution from piped stdin.
# Keep permissions explicit rather than using the unrestricted --allow-all mode.
if ((Split-Path $AgentExecutable -Leaf) -match '(?i)^copilot(\.exe)?$') {
    $psiArguments = "--allow-tool='read,write,shell' --no-ask-user -s"
} else {
    $psiArguments = $AgentArguments
}

$psi = [System.Diagnostics.ProcessStartInfo]::new()
$psi.FileName = $AgentExecutable
$psi.Arguments = $psiArguments
$psi.WorkingDirectory = (Get-Location).Path
$psi.UseShellExecute = $false
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $false
$psi.RedirectStandardError = $false

$p = [System.Diagnostics.Process]::Start($psi)
try {
    $p.StandardInput.WriteLine($prompt)
    $p.StandardInput.Close()
    $p.WaitForExit()
    exit $p.ExitCode
}
finally {
    if (-not $p.HasExited) { $p.Kill() }
    $p.Dispose()
}
