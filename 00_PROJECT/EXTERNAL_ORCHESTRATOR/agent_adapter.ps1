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
if ($agentLeaf -match '(?i)^codex\.cmd$') {
    $nativeCodex = [System.IO.Path]::ChangeExtension($AgentExecutable, ".exe")
    if (Test-Path -LiteralPath $nativeCodex -PathType Leaf) {
        $AgentExecutable = (Resolve-Path -LiteralPath $nativeCodex).Path
        $agentLeaf = Split-Path $AgentExecutable -Leaf
        Write-Host "Codex native executable selected: $AgentExecutable"
    }
}

if ($agentLeaf -match '(?i)^codex\.exe$') {
    $psiFileName = $AgentExecutable
    $psiArgumentList = if ($AgentArguments) { $AgentArguments -split '\s+' } else { @("--dangerously-bypass-approvals-and-sandbox", "exec", "-") }
} elseif ($agentLeaf -match '(?i)^codex\.ps1$') {
    $psiFileName = 'powershell.exe'
    $codexArgs = if ($AgentArguments) { $AgentArguments } else { '--dangerously-bypass-approvals-and-sandbox exec -' }
    $psiArgumentList = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $AgentExecutable) + ($codexArgs -split '\s+')
} else {
    Write-Error "Unsupported agent executable: $AgentExecutable"
    exit 1
}

$psi = [System.Diagnostics.ProcessStartInfo]::new()
$psi.FileName = $psiFileName
$psi.UseShellExecute = $false
$psi.CreateNoWindow = $true
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $false
$psi.RedirectStandardError = $false
foreach ($arg in $psiArgumentList) { [void]$psi.ArgumentList.Add($arg) }

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
