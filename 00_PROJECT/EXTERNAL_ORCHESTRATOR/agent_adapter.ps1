param(
    [string]$AgentExecutable = $env:BS_AGENT_EXECUTABLE,
    [string]$AgentArguments = $env:BS_AGENT_ARGUMENTS
)

$ErrorActionPreference = "Stop"

if (-not $env:BS_CURRENT_SHA) { throw "BS_CURRENT_SHA is not set." }

# Prefer the Codex installation explicitly managed for this workspace.
# Resolve the repository root from this script location, not from the caller's CWD.
if (-not $AgentExecutable) {
    $repoRoot = Split-Path $PSScriptRoot -Parent | Split-Path -Parent
    $flightPlanningRoot = Split-Path (Split-Path $repoRoot -Parent) -Parent
    $localCodex = Join-Path $flightPlanningRoot "TOOLS\codex\codex.cmd"
    if (Test-Path -LiteralPath $localCodex -PathType Leaf) {
        $AgentExecutable = (Resolve-Path -LiteralPath $localCodex).Path
        Write-Host "Agent auto-detected: Codex CLI ($AgentExecutable)"
    }
}

if (-not $AgentExecutable) {
    if ($env:BS_CODEX_EXECUTABLE -and (Test-Path -LiteralPath $env:BS_CODEX_EXECUTABLE -PathType Leaf)) {
        $AgentExecutable = (Resolve-Path -LiteralPath $env:BS_CODEX_EXECUTABLE).Path
        Write-Host "Agent auto-detected: Codex CLI ($AgentExecutable)"
    }
}

if (-not $AgentExecutable) {
    $codex = Get-Command codex -ErrorAction SilentlyContinue
    if ($codex) {
        $AgentExecutable = $codex.Source
        Write-Host "Agent auto-detected: Codex CLI ($AgentExecutable)"
    }
}

if (-not $AgentExecutable) {
    $copilot = Get-Command copilot -ErrorAction SilentlyContinue
    if ($copilot) {
        $AgentExecutable = $copilot.Source
        Write-Host "Agent auto-detected: GitHub Copilot CLI ($AgentExecutable)"
    }
}

if (-not $AgentExecutable) {
    Write-Host "No supported local development agent found. Install Codex CLI or configure BS_AGENT_EXECUTABLE."
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

Verify local HEAD matches the supplied SHA. Continue the current project work package from the recorded repository state.

Select and execute the next smallest concrete technical step that is supported by the existing project documents and does not require a user decision. This may be documentation decomposition, traceability, controlled-record preparation, implementation, or verification, as appropriate to the current work package.

Do not make product or architectural decisions. If a decision listed by the protocol is genuinely required and cannot be resolved from existing approved material, stop and return exit code 42.

Do not stop with exit code 0 merely because the user did not name a clause, file, or exact action: first inspect the recorded current work package, open checkpoints, existing records, and repository history and continue the next deterministic technical step. Only return 0 without a new commit when the current work package has no remaining deterministic technical work or when the protocol explicitly requires stopping.

Run appropriate tests after changes and do not claim CI success unless it belongs to the exact resulting SHA.
When no user decision is required, continue automatically. When a user decision is required, return 42.
"@

$agentLeaf = Split-Path $AgentExecutable -Leaf
if ($agentLeaf -match '(?i)^copilot(\.exe|\.cmd)?$') {
    $psiFileName = $AgentExecutable
    $psiArgumentList = @(
        "--allow-tool=read,write,shell",
        "--no-ask-user",
        "-s"
    )
} elseif ($agentLeaf -match '(?i)^codex(\.exe)?$') {
    $psiFileName = $AgentExecutable
    if ($AgentArguments) {
        $psiArgumentList = $AgentArguments -split '\s+'
    } else {
        $psiArgumentList = @("exec", "--sandbox", "workspace-write", "-")
    }
} elseif ($agentLeaf -match '(?i)^codex\.cmd$') {
    # .cmd files are command scripts, not native executables. Launch them through
    # cmd.exe and keep the command path quoted as a single argument. Do not use
    # /s here: it can consume the nested quotes around a path containing spaces.
    $psiFileName = $env:ComSpec
    $cmdArgs = if ($AgentArguments) { $AgentArguments } else { 'exec --sandbox workspace-write -' }
    $command = 'call "{0}" {1}' -f $AgentExecutable, $cmdArgs
    $psiArgumentList = @('/d', '/c', $command)
} elseif ($agentLeaf -match '(?i)^codex\.ps1$') {
    $psiFileName = 'powershell.exe'
    if ($AgentArguments) {
        $codexArgs = $AgentArguments
    } else {
        $codexArgs = 'exec --sandbox workspace-write -'
    }
    $psiArgumentList = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $AgentExecutable) + ($codexArgs -split '\s+')
} else {
    $psiFileName = $AgentExecutable
    $psiArgumentList = @()
    if ($AgentArguments) {
        $psiArgumentList = $AgentArguments -split '\s+'
    }
}

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $psiFileName
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
