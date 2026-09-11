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

$prompt = [Console]::In.ReadToEnd()

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
