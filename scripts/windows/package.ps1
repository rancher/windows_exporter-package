#Requires -Version 5.0
$ErrorActionPreference = "Stop"

Invoke-Expression -Command "$PSScriptRoot\version.ps1"

$DIR_PATH = Split-Path -Parent $MyInvocation.MyCommand.Definition
$SRC_PATH = (Resolve-Path "$DIR_PATH\..\..").Path
cd $SRC_PATH\package\windows


$TAG = $env:TAG
if (-not $TAG) {
    $TAG = ('{0}{1}' -f $env:VERSION, $env:SUFFIX)
}
$REPO = $env:REPO
if (-not $REPO) {
    $REPO = "rancher"
}

if ($TAG | Select-String -Pattern 'dirty') {
    $TAG = "dev"
}

if ($env:DRONE_TAG) {
    $TAG = $env:DRONE_TAG
}

$OS_VERSION = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' -ErrorAction Ignore).ProductName
$SERVER_TAG = ""

if ($OS_VERSION.Contains("2022")) {
    $SERVER_TAG = "ltsc2022"
}

if ($OS_VERSION.Contains("2019")) {
    $SERVER_TAG = "ltsc2019"
}

if (-not $SERVER_TAG) {
    if (-not $env:SERVER_TAG) {
        Write-Host Could not determine Windows Server Version
        exit 1
    }
    $SERVER_TAG = $env:SERVER_TAG
}

$IMAGE = ('{0}/windows-exporter-package:{1}-windows-{2}' -f $REPO, $TAG, $SERVER_TAG)

# ARCH should be set in version.ps1
if (-not $env:ARCH) {
    Write-Host Must specify a build architecture
    exit 1
}

# Build the exporter image
docker build `
    --build-arg SERVER_VERSION=$SERVER_TAG `
    --build-arg TARGET_ARCH=$env:ARCH `
    -t $IMAGE `
    -f Dockerfile .

Write-Host "Built $IMAGE"
