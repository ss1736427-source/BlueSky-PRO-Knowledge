param(
    [string]$AgentExecutable = $env:BS_AGENT_EXECUTABLE,
    [string]$AgentArguments = $env:BS_AGENT_ARGUMENTS
)

$ErrorActionPreference = "Stop"

if (-not $env:BS_CURRENT_SHA) { throw "BS_CURRENT_SHA is not set." }
if (-not $AgentExecutable) { throw "BS_AGENT_EXECUTABLE is not set." }

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

$psi = [System.Diagnostics.ProcessStartInfo]::new()
$psi.FileName = $AgentExecutable
$psi.Arguments = $AgentArguments
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
