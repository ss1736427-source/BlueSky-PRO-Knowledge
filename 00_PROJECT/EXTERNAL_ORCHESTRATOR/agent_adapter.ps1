$ErrorActionPreference = "Stop"

$AgentExecutable = $env:BS_AGENT_EXECUTABLE
$AgentArguments = $env:BS_AGENT_ARGUMENTS

if (-not $AgentExecutable) {
    $codexCommand = Get-Command codex.cmd -ErrorAction SilentlyContinue
    if ($codexCommand) {
        $AgentExecutable = $codexCommand.Source
    } else {
        $codexCommand = Get-Command codex.exe -ErrorAction SilentlyContinue
        if ($codexCommand) {
            $AgentExecutable = $codexCommand.Source
        } else {
            $defaultCodex = Join-Path $env:ProgramData "BlueSkyPro\codex.cmd"
            if (Test-Path -LiteralPath $defaultCodex -PathType Leaf) {
                $AgentExecutable = $defaultCodex
            } else {
                Write-Error "BS_AGENT_EXECUTABLE is not set and Codex CLI was not found in PATH. Set BS_AGENT_EXECUTABLE to the Codex executable."
                exit 1
            }
        }
    }
}

$agentLeaf = Split-Path $AgentExecutable -Leaf
$defaultArguments = @("--dangerously-bypass-approvals-and-sandbox", "exec", "-")
$codexArgs = if ($AgentArguments) { $AgentArguments -split '\s+' | Where-Object { $_ } } else { $defaultArguments }

# The orchestrator invokes this adapter without a redirected stdin. Reading
# Console.In directly therefore blocks on the interactive console. Build the
# deterministic project prompt from the environment supplied by the
# orchestrator instead.
$prompt = @"
BlueSky PRO development continuation.

Verified repository: $($env:BS_REPO)
Branch: $($env:BS_BRANCH)
Verified HEAD SHA: $($env:BS_CURRENT_SHA)

Read these repository files before acting:
- $($env:BS_PROTOCOL)
- $($env:BS_WORKING_RULES)

Verify local HEAD matches the supplied SHA. Continue the current project work package from the recorded repository state.

Select and execute the next smallest concrete technical step that is supported by the existing project documents and does not require a user decision. This may be documentation decomposition, traceability, controlled-record preparation, implementation, or verification, as appropriate to the current work package.

Do not make product or architectural decisions. If a decision listed by the protocol is genuinely required and cannot be resolved from existing approved material, stop and return exit code 42.

Do not stop with exit code 0 merely because the user did not name a clause, file, or exact action: first inspect the recorded current work package, open checkpoints, existing records, and repository history and continue the next deterministic technical step. Only return 0 without a new commit when the current work package has no remaining deterministic technical work or when the protocol explicitly requires stopping.

Run appropriate tests after changes and do not claim CI success unless it belongs to the exact resulting SHA.
When no user decision is required, continue automatically. When a user decision is required, return 42.

Reason for this continuation: $($env:BS_CI_REASON)
"@

if ($agentLeaf -match '(?i)^codex\.cmd$') {
    # Invoke the npm Windows shim directly from PowerShell. Do not construct a
    # cmd.exe command line: that path is sensitive to quoting and file
    # association behavior on Windows installations with spaces in PATHs.
    $prompt | & $AgentExecutable @codexArgs
    $exitCode = $LASTEXITCODE
} elseif ($agentLeaf -match '(?i)^codex\.exe$') {
    $prompt | & $AgentExecutable @codexArgs
    $exitCode = $LASTEXITCODE
} elseif ($agentLeaf -match '(?i)^codex\.ps1$') {
    $prompt | & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $AgentExecutable @codexArgs
    $exitCode = $LASTEXITCODE
} else {
    Write-Error "Unsupported agent executable: $AgentExecutable"
    exit 1
}

if ($null -eq $exitCode) {
    $exitCode = 1
}

exit $exitCode
