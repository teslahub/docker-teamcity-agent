# Docker teamcity-agent with multi .NET SDKs

Customized Teamcity Agent image Ubuntu 20.04 (Focal Fossa), add more tooks and .NET SDK

## Docker Hub and Dockerfile

https://hub.docker.com/r/teslaconsulting/teamcity-agent

[Dockerfile](https://github.com/teslahub/docker-teamcity-agent/blob/main/teamcity-agent/Dockerfile) on Github https://github.com/teslahub/docker-teamcity-agent

## Current version adding tools and SDKs

Update per build.

- TeamCity Agent: `2025.11.3-linux`
- .NET 10 SDK: 10.0.103
- .NET 9 SDK: 9.0.311
- .NET 8 SDK: 8.0.415
- Powershell Core: 7.6.0-preview.4
- MinVer Cli: 7.0.0
- Docker Compose v2: 5.1.0
