$ErrorActionPreference = "Stop"

$AgentExecutable = $env:BS_AGENT_EXECUTABLE
$AgentArguments = $env:BS_AGENT_ARGUMENTS

if (-not $AgentExecutable) {
    Write-Error "BS_AGENT_EXECUTABLE is not set."
    exit 42
}

$agentLeaf = Split-Path $AgentExecutable -Leaf
if ($agentLeaf -match '(?i)^codex\.cmd$') {
    $nativeCodex = [System.IO.Path]::ChangeExtension($AgentExecutable, ".exe")
    if (Test-Path -LiteralPath $nativeCodex -PathType Leaf) {
        $AgentExecutable = (Resolve-Path -LiteralPath $nativeCodex).Path
        $agentLeaf = Split-Path $AgentExecutable -Leaf
        Write-Host "Codex native executable selected: $AgentExecutable"
    } else {
        Write-Error "Codex native executable not found next to $AgentExecutable"
        exit 1
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
