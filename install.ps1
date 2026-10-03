[CmdletBinding()]
param(
    [string]$Destination = (Join-Path $env:APPDATA 'Rime'),
    [switch]$SkipDeploy,
    [string]$WeaselDeployer
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$managedFiles = @(
    'default.custom.yaml',
    'weasel.custom.yaml',
    'custom_phrase.txt'
)

if ([string]::IsNullOrWhiteSpace($Destination)) {
    throw 'Rime destination must not be empty.'
}

$sourceRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$destinationPath = [System.IO.Path]::GetFullPath($Destination)
New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null

foreach ($name in $managedFiles) {
    $source = Join-Path $sourceRoot $name
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "Managed Rime config is missing: $source"
    }
    Copy-Item -LiteralPath $source -Destination (Join-Path $destinationPath $name) -Force
}

if (-not $SkipDeploy) {
    $deployer = $WeaselDeployer
    if ([string]::IsNullOrWhiteSpace($deployer)) {
        $programRoots = @($env:ProgramFiles, ${env:ProgramFiles(x86)}) |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
            Select-Object -Unique

        $candidates = foreach ($root in $programRoots) {
            $rimeRoot = Join-Path $root 'Rime'
            if (Test-Path -LiteralPath $rimeRoot -PathType Container) {
                Get-ChildItem -LiteralPath $rimeRoot -Directory -Filter 'weasel-*' -ErrorAction SilentlyContinue |
                    Sort-Object Name -Descending |
                    ForEach-Object {
                        $candidate = Join-Path $_.FullName 'WeaselDeployer.exe'
                        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
                            $candidate
                        }
                    }
            }
        }
        $deployer = $candidates | Select-Object -First 1
    }

    if ([string]::IsNullOrWhiteSpace($deployer) -or -not (Test-Path -LiteralPath $deployer -PathType Leaf)) {
        throw 'WeaselDeployer.exe was not found. Install Weasel first, pass -WeaselDeployer, or use -SkipDeploy.'
    }

    & $deployer /deploy
    if ($LASTEXITCODE -ne 0) {
        throw "Weasel deployment failed with exit code $LASTEXITCODE."
    }
}

Write-Host "Rime configuration synchronized to $destinationPath"
