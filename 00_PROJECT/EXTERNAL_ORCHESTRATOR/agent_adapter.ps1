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

if ($agentLeaf -match '(?i)^codex\.exe$') {
    $psiFileName = $AgentExecutable
    $psiArguments = if ($AgentArguments) { $AgentArguments } else { $defaultArguments -join ' ' }
} elseif ($agentLeaf -match '(?i)^codex\.cmd$') {
    # npm installs Codex as a Windows .cmd shim. Invoke the shim through cmd.exe
    # with /c CALL so paths containing spaces are handled correctly and the shim's
    # exit code is propagated back to the orchestrator.
    $psiFileName = $env:ComSpec
    $codexArgs = if ($AgentArguments) { $AgentArguments } else { $defaultArguments -join ' ' }
    $quotedExecutable = '"' + $AgentExecutable.Replace('"', '\"') + '"'
    $commandLine = "call $quotedExecutable $codexArgs"
    $psiArguments = '/d /s /c "' + $commandLine.Replace('"', '\"') + '"'
} elseif ($agentLeaf -match '(?i)^codex\.ps1$') {
    $psiFileName = 'powershell.exe'
    $codexArgs = if ($AgentArguments) { $AgentArguments } else { '--dangerously-bypass-approvals-and-sandbox exec -' }
    $psiArguments = '-NoProfile -ExecutionPolicy Bypass -File "' + $AgentExecutable + '" ' + $codexArgs
} else {
    Write-Error "Unsupported agent executable: $AgentExecutable"
    exit 1
}

$psi = [System.Diagnostics.ProcessStartInfo]::new()
$psi.FileName = $psiFileName
$psi.Arguments = $psiArguments
$psi.UseShellExecute = $false
$psi.CreateNoWindow = $true
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $false
$psi.RedirectStandardError = $false

$process = [System.Diagnostics.Process]::new()
$process.StartInfo = $psi
if (-not $process.Start()) {
    Write-Error "Failed to start agent: $AgentExecutable"
    exit 1
}

$prompt = [Console]::In.ReadToEnd()
$process.StandardInput.Write($prompt)
$process.StandardInput.Close()
$process.WaitForExit()
exit $process.ExitCode
