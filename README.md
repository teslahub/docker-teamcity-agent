# Docker teamcity-agent with multi .NET SDKs

Customized Teamcity Agent image Ubuntu 20.04 (Focal Fossa), add more tooks and .NET SDK

## Docker Hub and Dockerfile

https://hub.docker.com/r/teslaconsulting/teamcity-agent

[Dockerfile](https://github.com/teslahub/docker-teamcity-agent/blob/main/teamcity-agent/Dockerfile) on Github https://github.com/teslahub/docker-teamcity-agent

## Current version adding tools and SDKs

Update per build.

- TeamCity Agent: `2022.04.7-linux`
- .NET 9 SDK: 9.0.100-preview.4.24267.66
- .NET 8 SDK: 8.0.301
- .NET 7 SDK: 7.0.410
- .NET 6 SDK: 6.0.423
- .NET 5 SDK: 5.0.408
- .NETCore 3.1 SDK: 3.1.426
- Powershell Core: 7.5.0-preview.2
- MinVer Cli: 5.0.0
- Docker Compose v2: 2.27.1
