ARG DOTNET_SDK_VERSION31_TAG=3.1-focal
ARG DOTNET_SDK_VERSION5_TAG=5.0-focal
ARG DOTNET_SDK_VERSION6_TAG=6.0-focal
ARG DOTNET_SDK_VERSION7_TAG=7.0-jammy
ARG DOTNET_SDK_VERSION8_TAG=8.0-preview-jammy
ARG MINVER_IMAGE_TAG=latest
ARG MINVER_IMAGE=teslaconsulting/minver-cli:$MINVER_IMAGE_TAG
ARG DOCKER_CLI_IMAGE=docker:cli
ARG TEAMCITYAGENT_IMAGE_REPOS=jetbrains/teamcity-agent
ARG TEAMCITYAGENT_IMAGE_TAG=2022.04.5-linux

FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION8_TAG} AS dotnetsdk8
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION7_TAG} AS dotnetsdk7
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION6_TAG} AS dotnetsdk6
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION5_TAG} AS dotnetsdk5
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION31_TAG} AS dotnetsdk3
FROM $MINVER_IMAGE AS minver
FROM $DOCKER_CLI_IMAGE AS dockercli

FROM scratch AS build
# make sure folder exist
WORKDIR /usr/local/bin
WORKDIR /usr/share
COPY --from=dotnetsdk3 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk5 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk6 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk7 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk8 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk8 /usr/share/powershell /usr/share/powershell
COPY --from=minver /usr/share/minver-cli /usr/share/minver-cli
COPY --from=dockercli /usr/local/libexec/docker/cli-plugins /usr/local/libexec/docker/cli-plugins

FROM ${TEAMCITYAGENT_IMAGE_REPOS}:${TEAMCITYAGENT_IMAGE_TAG} AS final

USER root

ARG DOTNET_SDK_VERSION31=3.1.0
ARG ASPNET_VERSION31=3.1.0
ARG DOTNET_VERSION31=3.1.0

ARG DOTNET_SDK_VERSION5=5.0.0
ARG ASPNET_VERSION5=5.0.0
ARG DOTNET_VERSION5=5.0.0

ARG DOTNET_SDK_VERSION6=6.0.0
ARG ASPNET_VERSION6=6.0.0
ARG DOTNET_VERSION6=6.0.0

ARG DOTNET_SDK_VERSION7=7.0.0
ARG ASPNET_VERSION7=7.0.0
ARG DOTNET_VERSION7=7.0.0

ARG DOTNET_SDK_VERSION8=8.0.0
ARG ASPNET_VERSION8=8.0.0
ARG DOTNET_VERSION8=8.0.0

ARG POWERSHELL_VERSION=7.2.6
ARG MINVER_VERSION=4.3.0
ARG DOCKER_COMPOSE_VERSION=2.20.0
# Install PowerShell global tool
# Install minver Console global tool
ENV DOTNET_SDK_VERSION31=${DOTNET_SDK_VERSION31} \
  ASPNET_VERSION31=${ASPNET_VERSION31} \
  DOTNET_VERSION31=${DOTNET_VERSION31} \
  \
  DOTNET_SDK_VERSION5=${DOTNET_SDK_VERSION5} \
  ASPNET_VERSION5=${ASPNET_VERSION5} \
  DOTNET_VERSION5=${DOTNET_VERSION5} \
  \
  DOTNET_SDK_VERSION6=${DOTNET_SDK_VERSION6} \
  ASPNET_VERSION6=${ASPNET_VERSION6} \
  DOTNET_VERSION6=${DOTNET_VERSION6} \
  \
  DOTNET_SDK_VERSION7=${DOTNET_SDK_VERSION7} \
  ASPNET_VERSION7=${ASPNET_VERSION7} \
  DOTNET_VERSION7=${DOTNET_VERSION7} \
  \
  DOTNET_SDK_VERSION8=${DOTNET_SDK_VERSION8} \
  ASPNET_VERSION8=${ASPNET_VERSION8} \
  DOTNET_VERSION8=${DOTNET_VERSION8} \
  \
  DOTNET_SDK_VERSION=${DOTNET_SDK_VERSION8} \
  ASPNET_VERSION=${ASPNET_VERSION8} \
  DOTNET_VERSION=${DOTNET_VERSION8} \
  \
  POWERSHELL_VERSION=${POWERSHELL_VERSION} \
  POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Ubuntu-20.04 \
  DOTNET_MINVER_VERSION=${MINVER_VERSION} \
  DOCKER_COMPOSE_VERSION=${DOCKER_COMPOSE_VERSION}

COPY --from=build /usr /usr

RUN apt-get update \
  # && apt-get install docker-compose-plugin -y \ -> use docker:cli because package got delayed
  && apt-get upgrade -y \
  && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
  && chmod 755 /usr/share/powershell/pwsh \
  && ln -s /usr/share/minver-cli/minver /usr/bin/minver \
  && chmod +x /usr/share/minver-cli/minver \
  && rm /usr/local/bin/docker-compose \
  && ln -s /usr/local/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose \
  && chmod +x /usr/libexec/docker/cli-plugins/docker-* \
  # Install module Pester - for root user
  && pwsh -Command "Install-Module -Name Pester -Scope AllUsers -Force" \
  && dotnet --help \
  && dotnet --info \
  && dotnet nuget locals all --clear \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

USER buildagent

# ENV  PATH="$PATH:/home/buildagent/.dotnet/tools"
# RUN dotnet tool install --global minver-cli --version $DOTNET_MINVER_VERSION
