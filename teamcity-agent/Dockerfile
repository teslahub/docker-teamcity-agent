ARG DOTNET_SDK_VERSION31=3.1.421
ARG DOTNET_SDK_VERSION5=5.0.408
ARG DOTNET_SDK_VERSION6=6.0.302
ARG MINVER_IMAGE_TAG=4.2.0
ARG MINVER_IMAGE=teslaconsulting/minver-cli:$MINVER_IMAGE_TAG
ARG TEAMCITYAGENT_IMAGE_REPOS=jetbrains/teamcity-agent
ARG TEAMCITYAGENT_IMAGE_TAG=2022.04.2-linux
ARG DOCKER_COMPOSE_VERSION=1.29.2

FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION6}-focal AS dotnetsdk6
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION5}-focal AS dotnetsdk5
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION31}-focal AS dotnetsdk3
FROM $MINVER_IMAGE AS minver
FROM teslaconsulting/docker-compose:$DOCKER_COMPOSE_VERSION AS dockercompose

FROM scratch AS build
# make sure folder exist
WORKDIR /usr/local/bin
WORKDIR /usr/share
COPY --from=dotnetsdk3 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk5 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk6 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk6 /usr/share/powershell /usr/share/powershell
COPY --from=minver /usr/share/minver-cli /usr/share/minver-cli
COPY --from=dockercompose /usr/local/bin/docker-compose /usr/local/bin/docker-compose

FROM ${TEAMCITYAGENT_IMAGE_REPOS}:${TEAMCITYAGENT_IMAGE_TAG} AS final

USER root

ARG DOTNET_VERSION6=6.0.7
ARG DOTNET_VERSION5=5.0.17
ARG DOTNET_VERSION31=3.1.27
ARG DOTNET_SDK_VERSION6
ARG DOTNET_SDK_VERSION5
ARG DOTNET_SDK_VERSION31
ARG POWERSHELL_VERSION=7.2.5
ARG MINVER_IMAGE_TAG
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
  DOTNET_MINVER_VERSION=$MINVER_IMAGE_TAG

COPY --from=build /usr /usr

RUN ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
  && chmod 755 /usr/share/powershell/pwsh \
  && ln -s /usr/share/minver-cli/minver /usr/bin/minver \
  && chmod 755 /usr/share/minver-cli/minver \
  && chmod 755 /usr/local/bin/docker-compose \
  # Install module Pester - for root user
  && pwsh -Command "Install-Module -Name Pester -Scope AllUsers -Force" \
  && dotnet nuget locals all --clear

USER buildagent

# ENV  PATH="$PATH:/home/buildagent/.dotnet/tools"
# RUN dotnet tool install --global minver-cli --version $DOTNET_MINVER_VERSION
