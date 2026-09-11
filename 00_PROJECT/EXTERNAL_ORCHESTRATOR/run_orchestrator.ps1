param(
    [string]$Repo = "ss1736427-source/BlueSky-PRO-Knowledge",
    [string]$AgentCommand = ""
)

$ErrorActionPreference = "Stop"
if (-not $env:GITHUB_TOKEN) { throw "GITHUB_TOKEN is not set." }
$env:BS_REPO = $Repo
$env:BS_BRANCH = "main"
$env:BS_POLL_SECONDS = "5"
if ($AgentCommand) { $env:BS_AGENT_COMMAND = $AgentCommand }
python "$PSScriptRoot\bluesky_orchestrator.py"
