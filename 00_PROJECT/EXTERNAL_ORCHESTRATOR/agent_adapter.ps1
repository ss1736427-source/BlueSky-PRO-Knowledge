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

if (-not (Test-Path -LiteralPath $AgentExecutable -PathType Leaf)) {
    $resolved = Get-Command $AgentExecutable -ErrorAction SilentlyContinue
    if ($resolved) {
        $AgentExecutable = $resolved.Source
    } else {
        Write-Error "Agent executable not found: $AgentExecutable"
        exit 1
    }
}

$defaultArguments = @("--dangerously-bypass-approvals-and-sandbox", "exec", "-")
$codexArgs = if ($AgentArguments) { $AgentArguments -split '\s+' | Where-Object { $_ } } else { $defaultArguments }

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

$promptFile = Join-Path $env:TEMP ("bluesky-codex-prompt-{0}.txt" -f [guid]::NewGuid().ToString("N"))

try {
    [System.IO.File]::WriteAllText($promptFile, $prompt, [System.Text.UTF8Encoding]::new($false))

    # Invoke the CLI from PowerShell itself. PowerShell correctly handles a
    # quoted .cmd path containing spaces and its native-command redirection
    # supplies a real EOF to `codex exec -` without an extra cmd.exe process.
    & $AgentExecutable @codexArgs < $promptFile
    $agentExitCode = $LASTEXITCODE

    if ($null -eq $agentExitCode) {
        $agentExitCode = 0
    }
    exit $agentExitCode
} finally {
    Remove-Item -LiteralPath $promptFile -Force -ErrorAction SilentlyContinue
}
