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

function Quote-ProcessArgument([string]$Value) {
    if ($Value -notmatch '[\s"]') {
        return $Value
    }
    return '"' + ($Value -replace '(\\*)"', '$1$1\"' -replace '(\\+)$', '$1$1') + '"'
}

$psi = [System.Diagnostics.ProcessStartInfo]::new()
$psi.UseShellExecute = $false
$psi.CreateNoWindow = $true
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true

if ($agentLeaf -match '(?i)^codex\.cmd$') {
    # npm installs Codex as a Windows .cmd shim. Run the shim through cmd.exe
    # explicitly and capture stdin/stdout/stderr so the exec process receives
    # EOF after the deterministic prompt and cannot hang on the parent console.
    $psi.FileName = Join-Path $env:SystemRoot "System32\cmd.exe"
    $command = '"' + $AgentExecutable + '"'
    $psi.Arguments = '/d /s /c call ' + $command + ' ' + (($codexArgs | ForEach-Object { Quote-ProcessArgument $_ }) -join ' ')
} elseif ($agentLeaf -match '(?i)^codex\.exe$') {
    $psi.FileName = $AgentExecutable
    $psi.Arguments = ($codexArgs | ForEach-Object { Quote-ProcessArgument $_ }) -join ' '
} elseif ($agentLeaf -match '(?i)^codex\.ps1$') {
    $psi.FileName = Join-Path $env:SystemRoot "System32\WindowsPowerShell\v1.0\powershell.exe"
    $psi.Arguments = '-NoProfile -ExecutionPolicy Bypass -File ' + (Quote-ProcessArgument $AgentExecutable) + ' ' + (($codexArgs | ForEach-Object { Quote-ProcessArgument $_ }) -join ' ')
} else {
    Write-Error "Unsupported agent executable: $AgentExecutable"
    exit 1
}

$process = [System.Diagnostics.Process]::new()
$process.StartInfo = $psi
try {
    if (-not $process.Start()) {
        Write-Error "Failed to start agent: $AgentExecutable"
        exit 1
    }

    $process.StandardInput.Write($prompt)
    $process.StandardInput.Close()

    $stdoutTask = $process.StandardOutput.ReadToEndAsync()
    $stderrTask = $process.StandardError.ReadToEndAsync()
    $process.WaitForExit()

    $stdout = $stdoutTask.GetAwaiter().GetResult()
    $stderr = $stderrTask.GetAwaiter().GetResult()
    if ($stdout) { [Console]::Out.Write($stdout) }
    if ($stderr) { [Console]::Error.Write($stderr) }

    exit $process.ExitCode
} finally {
    $process.Dispose()
}
