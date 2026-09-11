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

# GitHub Copilot CLI accepts a comma-separated tool list.
# Windows PowerShell 5.1 does not expose ProcessStartInfo.ArgumentList,
# so use the legacy Arguments property with Windows-compatible quoting.
if ((Split-Path $AgentExecutable -Leaf) -match '(?i)^copilot(\.exe)?$') {
    $psiArgumentList = @(
        "--allow-tool=read,write,shell",
        "--no-ask-user",
        "-s"
    )
} else {
    $psiArgumentList = @()
    if ($AgentArguments) {
        $psiArgumentList = $AgentArguments -split '\s+'
    }
}

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $AgentExecutable
$psi.WorkingDirectory = (Get-Location).Path
$psi.UseShellExecute = $false
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $false
$psi.RedirectStandardError = $false

if ($psi.PSObject.Properties.Name -contains 'ArgumentList') {
    foreach ($arg in $psiArgumentList) {
        [void]$psi.ArgumentList.Add($arg)
    }
} else {
    $quotedArgs = foreach ($arg in $psiArgumentList) {
        '"' + ($arg -replace '(\\*)"', '$1$1\"' -replace '(\\+)$', '$1$1') + '"'
    }
    $psi.Arguments = ($quotedArgs -join ' ')
}

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
