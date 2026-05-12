ARG DOTNET_SDK_VERSION8_TAG=8.0-jammy
ARG DOTNET_SDK_VERSION9_TAG=9.0-noble
ARG DOTNET_SDK_VERSION10_TAG=10.0-noble
ARG TEAMCITYAGENT_IMAGE_REPOS=jetbrains/teamcity-agent
ARG TEAMCITYAGENT_IMAGE_TAG=2026.1-linux

FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION10_TAG} AS dotnetsdk10
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION9_TAG} AS dotnetsdk9
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION8_TAG} AS dotnetsdk8

FROM scratch AS build
# make sure folder exist
WORKDIR /usr/local/bin
WORKDIR /usr/share
# ERROR: failed to build: failed to solve: variable expansion is not supported for --from, define a new stage with FROM using ARG from global scope as a workaround
# COPY --from=mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION9_TAG} /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk8 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk9 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk10 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk10 /usr/share/powershell /usr/share/powershell
COPY --from=teslaconsulting/minver-cli:latest /usr/share/minver-cli /usr/share/minver-cli
COPY --from=docker:latest /usr/local/libexec/docker/cli-plugins /usr/local/libexec/docker/cli-plugins
COPY --from=docker:latest /usr/local/bin/containerd* /usr/local/bin/docker* /usr/local/bin/

FROM ${TEAMCITYAGENT_IMAGE_REPOS}:${TEAMCITYAGENT_IMAGE_TAG} AS final

USER root

ARG DOTNET_SDK_VERSION8=8.0.415
ARG ASPNET_VERSION8=8.0.21
ARG DOTNET_VERSION8=8.0.21

ARG DOTNET_SDK_VERSION9=9.0.309
ARG ASPNET_VERSION9=9.0.12
ARG DOTNET_VERSION9=9.0.12

ARG DOTNET_SDK_VERSION10=10.0.102
ARG ASPNET_VERSION10=10.0.2
ARG DOTNET_VERSION10=10.0.2

ARG POWERSHELL_VERSION=7.6.0-preview.4
ARG POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Ubuntu-24.04
ARG MINVER_VERSION=7.0.0
ARG DOCKER_COMPOSE_VERSION=2.24.6

ENV DOTNET_SDK_VERSION8=${DOTNET_SDK_VERSION8} \
  ASPNET_VERSION8=${ASPNET_VERSION8} \
  DOTNET_VERSION8=${DOTNET_VERSION8} \
  \
  DOTNET_SDK_VERSION9=${DOTNET_SDK_VERSION9} \
  ASPNET_VERSION9=${ASPNET_VERSION9} \
  DOTNET_VERSION9=${DOTNET_VERSION9} \
  \
  DOTNET_SDK_VERSION10=${DOTNET_SDK_VERSION10} \
  ASPNET_VERSION10=${ASPNET_VERSION10} \
  DOTNET_VERSION10=${DOTNET_VERSION10} \
  \
  DOTNET_SDK_VERSION=${DOTNET_SDK_VERSION10} \
  ASPNET_VERSION=${ASPNET_VERSION10} \
  DOTNET_VERSION=${DOTNET_VERSION10} \
  \
  POWERSHELL_VERSION=${POWERSHELL_VERSION} \
  POWERSHELL_DISTRIBUTION_CHANNEL=${POWERSHELL_DISTRIBUTION_CHANNEL} \
  DOTNET_MINVER_VERSION=${MINVER_VERSION} \
  DOCKER_COMPOSE_VERSION=${DOCKER_COMPOSE_VERSION}

COPY --from=build /usr /usr

RUN  ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
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
  && dotnet nuget locals all --clear

USER buildagent
