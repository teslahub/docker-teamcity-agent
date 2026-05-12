[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)] [string] $Version, # = '2026.1-20260512-01',
    [Parameter(Mandatory = $false)] [string] $SourceImageTag = '2026.1-linux',
    [Parameter(Mandatory = $false)] [string[]] $DockerRepository = @('teslaconsulting/teamcity-agent'),
    [Parameter(Mandatory = $false)] [string] $DockerContext = $null,
    [Parameter(Mandatory = $false)] [string] $Branch,
    [Parameter(Mandatory = $false)] [string] $Sha,
    [Parameter(Mandatory = $false)] [string] $DotnetSdkVersion8Tag = '8.0-jammy',
    [Parameter(Mandatory = $false)] [string] $DotnetSdkVersion9Tag = '9.0-noble',
    [Parameter(Mandatory = $false)] [string] $DotnetSdkVersion10Tag = '10.0.202-noble-amd64',
    [Parameter(Mandatory = $false)] [switch] $NoSquash,
    [Parameter(Mandatory = $false)] [switch] $Latest,
    [Parameter(Mandatory = $false)] [switch] $ShowCommand,
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
if ($Sha) { private:AddImageTag "sha-$($Sha)" }
if ($Branch) { private:AddImageTag $Branch }
if (!$Version) {
    $Version = ($SourceImageTag.EndsWith('-linux') ? $SourceImageTag.Substring(0, $SourceImageTag.Length - 5) : $SourceImageTag) + (Get-Date).ToString('yyyyMMdd-HHmmss')
}
#Write-Host "Version: $Version"

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

[string[]]$paramsContext = if ($DockerContext) { @('--context', $DockerContext) } else { [string[]]@() }

[string[]]$params = @('build', "$($root)/teamcity-agent")

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
$minver_ver = $(docker @paramsContext run --rm --pull=always teslaconsulting/minver-cli:latest minver --version)
Write-Output "Minver Version:`n$minver_ver"
private:AddBuildArg 'MINVER_VERSION' $minver_ver

$docker_compose_version = $(docker @paramsContext run --rm --pull=always docker:latest docker compose version)
Write-Output "Docker compose version raw: $docker_compose_version"
$docker_compose_version = $docker_compose_version.Substring('Docker Compose version v'.Length)
Write-Output "Docker compose version only: '$docker_compose_version'"
private:AddBuildArg 'DOCKER_COMPOSE_VERSION' $docker_compose_version

$dotnet_vers = $(docker @paramsContext run --rm --pull=always mcr.microsoft.com/dotnet/sdk:$DotnetSdkVersion8Tag sh -c 'echo $DOTNET_SDK_VERSION;echo $ASPNET_VERSION;echo $DOTNET_VERSION')
Write-Output ".NET 8.0: Version SDK:$($dotnet_vers[0]) ASP.NET:$($dotnet_vers[1]) .NETCore:$($dotnet_vers[2])"
private:AddBuildArg 'DOTNET_SDK_VERSION8' $dotnet_vers[0]
private:AddBuildArg 'ASPNET_VERSION8' $dotnet_vers[1]
private:AddBuildArg 'DOTNET_VERSION8' $dotnet_vers[2]

$dotnet_vers = $(docker @paramsContext run --rm --pull=always mcr.microsoft.com/dotnet/sdk:$DotnetSdkVersion9Tag sh -c 'echo $DOTNET_SDK_VERSION;echo $ASPNET_VERSION;echo $DOTNET_VERSION')
Write-Output ".NET 9.0: Version SDK:$($dotnet_vers[0]) ASP.NET:$($dotnet_vers[1]) .NETCore:$($dotnet_vers[2])"
private:AddBuildArg 'DOTNET_SDK_VERSION9' $dotnet_vers[0]
private:AddBuildArg 'ASPNET_VERSION9' $dotnet_vers[1]
private:AddBuildArg 'DOTNET_VERSION9' $dotnet_vers[2]

$dotnet_vers = $(docker @paramsContext run --rm --pull=always mcr.microsoft.com/dotnet/sdk:$DotnetSdkVersion10Tag sh -c 'echo $DOTNET_SDK_VERSION;echo $ASPNET_VERSION;echo $DOTNET_VERSION;pwsh --version;echo $POWERSHELL_DISTRIBUTION_CHANNEL')
Write-Output ".NET 10.0: Version SDK:$($dotnet_vers[0]) ASP.NET:$($dotnet_vers[1]) .NETCore:$($dotnet_vers[2]) PowerShell:$($dotnet_vers[3].SubString(11)) channel:$($dotnet_vers[4])"
# private:AddBuildArg 'DOTNET_SDK_VERSION10' $dotnet_vers[0]
# private:AddBuildArg 'ASPNET_VERSION10' $dotnet_vers[1]
# private:AddBuildArg 'DOTNET_VERSION10' $dotnet_vers[2]
private:AddBuildArg 'POWERSHELL_VERSION' $dotnet_vers[3].SubString(11)
private:AddBuildArg 'POWERSHELL_DISTRIBUTION_CHANNEL' $dotnet_vers[4] # 'PSDocker-DotnetSDK-Ubuntu-24.04'

private:AddBuildArg 'DOTNET_SDK_VERSION8_TAG' $DotnetSdkVersion8Tag
private:AddBuildArg 'DOTNET_SDK_VERSION9_TAG' $DotnetSdkVersion9Tag
# private:AddBuildArg 'DOTNET_SDK_VERSION10_TAG' $DotnetSdkVersion10Tag
#===========================================================

Write-Verbose "Execute: docker $paramsContext $params"
if (!$ShowCommand) {
    docker @paramsContext @params

    if (!$?) {
        $saveLASTEXITCODE = $LASTEXITCODE
        Write-Error "docker build failed (exit=$saveLASTEXITCODE)"
        exit $saveLASTEXITCODE
    }

    if (!$WhatIf -And $dockerImages -And !$ShowCommand) {
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
}
