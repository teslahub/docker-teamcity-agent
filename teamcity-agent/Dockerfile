ARG DOTNET_SDK_VERSION31=3.1.423
ARG DOTNET_SDK_VERSION5=5.0.408
ARG DOTNET_SDK_VERSION6=6.0.401
ARG MINVER_IMAGE_TAG=4.2.0
ARG MINVER_IMAGE=teslaconsulting/minver-cli:$MINVER_IMAGE_TAG
ARG TEAMCITYAGENT_IMAGE_REPOS=jetbrains/teamcity-agent
ARG TEAMCITYAGENT_IMAGE_TAG=2022.04.4-linux
ARG DOCKER_CLI_IMAGE=docker:cli

FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION6}-focal AS dotnetsdk6
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION5}-focal AS dotnetsdk5
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION31}-focal AS dotnetsdk3
FROM $MINVER_IMAGE AS minver
FROM $DOCKER_CLI_IMAGE AS dockercli

FROM scratch AS build
# make sure folder exist
WORKDIR /usr/local/bin
WORKDIR /usr/share
COPY --from=dotnetsdk3 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk5 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk6 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk6 /usr/share/powershell /usr/share/powershell
COPY --from=minver /usr/share/minver-cli /usr/share/minver-cli
COPY --from=dockercli /usr/libexec/docker/cli-plugins /usr/libexec/docker/cli-plugins

FROM ${TEAMCITYAGENT_IMAGE_REPOS}:${TEAMCITYAGENT_IMAGE_TAG} AS final

USER root

ARG DOTNET_VERSION6=6.0.9
ARG DOTNET_VERSION5=5.0.17
ARG DOTNET_VERSION31=3.1.29
ARG DOTNET_SDK_VERSION6
ARG DOTNET_SDK_VERSION5
ARG DOTNET_SDK_VERSION31
ARG POWERSHELL_VERSION=7.2.6
ARG MINVER_IMAGE_TAG
ARG DOCKER_COMPOSE_VERSION=2.11.2
# Install PowerShell global tool
# Install minver Console global tool
ENV DOTNET_VERSION31=${DOTNET_VERSION31} \
  DOTNET_SDK_VERSION31=${DOTNET_SDK_VERSION31} \
  DOTNET_VERSION5=${DOTNET_VERSION5} \
  DOTNET_SDK_VERSION5=${DOTNET_SDK_VERSION5} \
  DOTNET_VERSION=${DOTNET_VERSION6} \
  ASPNET_VERSION=${DOTNET_VERSION6} \
  DOTNET_SDK_VERSION=${DOTNET_SDK_VERSION6} \
  POWERSHELL_VERSION=${POWERSHELL_VERSION} \
  POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Ubuntu-20.04 \
  DOTNET_MINVER_VERSION=${MINVER_IMAGE_TAG} \
  DOCKER_COMPOSE_VERSION=${DOCKER_COMPOSE_VERSION}

COPY --from=build /usr /usr

RUN ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
  && chmod 755 /usr/share/powershell/pwsh \
  && ln -s /usr/share/minver-cli/minver /usr/bin/minver \
  && chmod +x /usr/share/minver-cli/minver \
  && rm /usr/local/bin/docker-compose \
  && ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose \
  && chmod +x /usr/libexec/docker/cli-plugins/docker-* \
  # Install module Pester - for root user
  && pwsh -Command "Install-Module -Name Pester -Scope AllUsers -Force" \
  && dotnet nuget locals all --clear

USER buildagent

# ENV  PATH="$PATH:/home/buildagent/.dotnet/tools"
# RUN dotnet tool install --global minver-cli --version $DOTNET_MINVER_VERSION
