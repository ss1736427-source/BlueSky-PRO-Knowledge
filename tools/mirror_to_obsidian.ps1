param(
    [Parameter(Mandatory=$true)]
    [string]$SourceRoot,

    [Parameter(Mandatory=$true)]
    [string]$ObsidianMirror
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $SourceRoot -PathType Container)) {
    throw "SourceRoot does not exist: $SourceRoot"
}

if (-not (Test-Path -LiteralPath $ObsidianMirror -PathType Container)) {
    New-Item -ItemType Directory -Path $ObsidianMirror -Force | Out-Null
}

# Mirror the working tree, but keep Obsidian's own workspace and Git metadata out of the mirror.
robocopy $SourceRoot $ObsidianMirror /MIR /FFT /R:2 /W:2 /XJ /XD "$SourceRoot\.git" "$SourceRoot\.github" "$SourceRoot\.obsidian" "$ObsidianMirror\.git" "$ObsidianMirror\.obsidian" | Out-Host

$code = $LASTEXITCODE
if ($code -ge 8) {
    throw "robocopy failed with exit code $code"
}

Write-Host "BlueSky PRO mirror completed: $SourceRoot -> $ObsidianMirror"
