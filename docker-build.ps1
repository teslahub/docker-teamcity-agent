[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)] [string] $Version = '2022.04.5-20240327-01',
    [Parameter(Mandatory = $false)] [string] $SourceImageTag = '2022.04.5-linux',
    [Parameter(Mandatory = $false)] [string[]] $DockerRepository = @('teslaconsulting/teamcity-agent'),
    [Parameter(Mandatory = $false)] [string] $Branch,
    [Parameter(Mandatory = $false)] [string] $Sha,
    [Parameter(Mandatory = $false)] [switch] $NoSquash,
    [Parameter(Mandatory = $false)] [switch] $Latest,
    [Parameter(Mandatory = $false)] [switch] $WhatIf
)

function AddImageTag($imageTag) {
    if ($imageTag -And !($script:imageTags -Contains $imageTag)) {
        $script:imageTags += @($imageTag)
    }
}

function private:AddTag($pattern, $replacement) {
    if (!$replacement) { $replacement = '${1}' }
    if ($pattern -And $Version -match $pattern) {
        $tag = $Version -replace $pattern, $replacement
        if ($tag) {
            AddImageTag $tag
        }
    }
}

function private:AddDockerImage($image) {
    if ($image -And !($script:dockerImages -Contains $image)) {
        $script:dockerImages += @($image)
    }
}

function private:AddBuildArg($buildArgKey, $buildArgValue, $valuePattern) {
    if ($buildArgValue -And (!$valuePattern -Or $buildArgValue -match $valuePattern)) {
        $script:params += @('--build-arg', "$($buildArgKey)=$($buildArgValue)")
    }
}

$root = Split-Path $MyInvocation.MyCommand.Path -Parent -Resolve

$imageTags = @()
private:AddImageTag "sha-$($Sha)"
private:AddImageTag $Branch
AddTag '^(\d+)\.\d+(\.\d+)?(-.+)?$'
AddTag '^(\d+\.\d+)(\.\d+)?(-.+)?$'
AddTag '^(\d+\.\d+(\.\d+)?)(-.+)?$'
AddTag '^(\d+\.\d+(\.\d+)?(-.+)?)$'
if ($Latest) {
    private:AddImageTag 'latest'
}

$dockerImages = @()
foreach ($dockerRepos in $dockerRepository) {
    foreach ($imageTag in $imageTags) {
        private:AddDockerImage "$($dockerRepos):$($imageTag)"
    }
}

$params = @('build', "$($root)/teamcity-agent")

$params += @('--pull', '--progress=plain')

if (!$NoSquash) {
    $params += @('--squash')
}

private:AddBuildArg 'TEAMCITYAGENT_IMAGE_TAG' $SourceImageTag

Write-Output "Docker images: $dockerImages"
foreach ($dockerImage in $dockerImages) {
    $params += @("--tag=$($dockerImage)")
}

#===========================================================
$minver_help = $(docker run --rm teslaconsulting/minver-cli:latest minver --help)
Write-Output "Minver help:`n$minver_help"
$minver_version = $minver_help[0] -Replace '^[^0-9]+([0-9.]+)[^0-9].*$', '$1'
Write-Output "Minver version: $minver_version"
private:AddBuildArg 'MINVER_VERSION' $minver_version

$docker_compose_version = $(docker run --rm docker:cli docker compose version)
Write-Output "Docker compose version raw: $docker_compose_version"
$docker_compose_version = $docker_compose_version.Substring('Docker Compose version v'.Length)
Write-Output "Docker compose version only: '$docker_compose_version'"
private:AddBuildArg 'DOCKER_COMPOSE_VERSION' $docker_compose_version

$dotnet_info_raw = $(docker run --rm mcr.microsoft.com/dotnet/sdk:3.1-focal dotnet --info) -join ' '
$dotnet_sdk_version = $dotnet_info_raw -replace '^.+\.NET Core SDKs installed:[^0-9]+([0-9.]+)[^0-9].*$', '$1'
$aspnetcore_version = $dotnet_info_raw -replace '^.+Microsoft.AspNetCore.App\s+([0-9.]+)[^0-9.].*$', '$1'
$dotnet_version = $dotnet_info_raw -replace '^.+Microsoft.NETCore.App\s+([0-9.]+)[^0-9.].*$', '$1'
Write-Output ".NETCore 3.1: Version SDK:$dotnet_sdk_version ASP.NET:$aspnetcore_version .NETCore:$dotnet_version"
private:AddBuildArg 'DOTNET_SDK_VERSION31' $dotnet_sdk_version
private:AddBuildArg 'ASPNET_VERSION31' $aspnetcore_version
private:AddBuildArg 'DOTNET_VERSION31' $dotnet_version

$dotnet_vers = $(docker run --rm mcr.microsoft.com/dotnet/sdk:5.0-focal sh -c 'echo $DOTNET_SDK_VERSION;echo $ASPNET_VERSION;echo $DOTNET_VERSION')
Write-Output ".NET 5.0: Version SDK:$($dotnet_vers[0]) ASP.NET:$($dotnet_vers[1]) .NETCore:$($dotnet_vers[2])"
private:AddBuildArg 'DOTNET_SDK_VERSION5' $dotnet_vers[0]
private:AddBuildArg 'ASPNET_VERSION5' $dotnet_vers[1]
private:AddBuildArg 'DOTNET_VERSION5' $dotnet_vers[2]

$dotnet_vers = $(docker run --rm mcr.microsoft.com/dotnet/sdk:6.0-focal sh -c 'echo $DOTNET_SDK_VERSION;echo $ASPNET_VERSION;echo $DOTNET_VERSION')
Write-Output ".NET 6.0: Version SDK:$($dotnet_vers[0]) ASP.NET:$($dotnet_vers[1]) .NETCore:$($dotnet_vers[2])"
private:AddBuildArg 'DOTNET_SDK_VERSION6' $dotnet_vers[0]
private:AddBuildArg 'ASPNET_VERSION6' $dotnet_vers[1]
private:AddBuildArg 'DOTNET_VERSION6' $dotnet_vers[2]

$dotnet_vers = $(docker run --rm mcr.microsoft.com/dotnet/sdk:7.0-jammy sh -c 'echo $DOTNET_SDK_VERSION;echo $ASPNET_VERSION;echo $DOTNET_VERSION')
Write-Output ".NET 7.0: Version SDK:$($dotnet_vers[0]) ASP.NET:$($dotnet_vers[1]) .NETCore:$($dotnet_vers[2])"
private:AddBuildArg 'DOTNET_SDK_VERSION7' $dotnet_vers[0]
private:AddBuildArg 'ASPNET_VERSION7' $dotnet_vers[1]
private:AddBuildArg 'DOTNET_VERSION7' $dotnet_vers[2]

$dotnet_vers = $(docker run --rm mcr.microsoft.com/dotnet/sdk:8.0-jammy sh -c 'echo $DOTNET_SDK_VERSION;echo $ASPNET_VERSION;echo $DOTNET_VERSION;pwsh --version')
Write-Output ".NET 8.0: Version SDK:$($dotnet_vers[0]) ASP.NET:$($dotnet_vers[1]) .NETCore:$($dotnet_vers[2]) PowerShell:$($dotnet_vers[3].SubString(11))"
private:AddBuildArg 'DOTNET_SDK_VERSION8' $dotnet_vers[0]
private:AddBuildArg 'ASPNET_VERSION8' $dotnet_vers[1]
private:AddBuildArg 'DOTNET_VERSION8' $dotnet_vers[2]

$dotnet_vers = $(docker run --rm mcr.microsoft.com/dotnet/sdk:9.0-preview-jammy sh -c 'echo $DOTNET_SDK_VERSION;echo $ASPNET_VERSION;echo $DOTNET_VERSION;pwsh --version')
Write-Output ".NET 9.0: Version SDK:$($dotnet_vers[0]) ASP.NET:$($dotnet_vers[1]) .NETCore:$($dotnet_vers[2]) PowerShell:$($dotnet_vers[3].SubString(11))"
private:AddBuildArg 'DOTNET_SDK_VERSION9' $dotnet_vers[0]
private:AddBuildArg 'ASPNET_VERSION9' $dotnet_vers[1]
private:AddBuildArg 'DOTNET_VERSION9' $dotnet_vers[2]
private:AddBuildArg 'POWERSHELL_VERSION' $dotnet_vers[3].SubString(11)
private:AddBuildArg 'POWERSHELL_DISTRIBUTION_CHANNEL' 'PSDocker-DotnetSDK-Ubuntu-20.04'
#===========================================================

Write-Verbose "Execute: docker $params"
docker @params

if (!$?) {
    $saveLASTEXITCODE = $LASTEXITCODE
    Write-Error "docker build failed (exit=$saveLASTEXITCODE)"
    exit $saveLASTEXITCODE
}

if (!$WhatIf -And $dockerImages) {
    Write-Host "Pushing docker images"
    foreach ($dockerImage in $dockerImages) {
        docker push $dockerImage
        if (!$?) {
            $saveLASTEXITCODE = $LASTEXITCODE
            Write-Error "docker push failed (exit=$saveLASTEXITCODE)"
            exit $saveLASTEXITCODE
        }
    }
}
