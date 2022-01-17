ARG DOTNET_SDK_VERSION31=3.1.416
ARG DOTNET_SDK_VERSION5=5.0.404
ARG DOTNET_SDK_VERSION6=6.0.101
ARG MINVER_IMAGE_TAG=2.5.0
ARG MINVER_IMAGE=teslaconsulting/minver-cli:$MINVER_IMAGE_TAG
ARG TEAMCITYAGENT_IMAGE_TAG=2021.2.2-linux

FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION6}-focal AS dotnetsdk6
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION5}-focal AS dotnetsdk5
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION31}-focal AS dotnetsdk3
FROM $MINVER_IMAGE AS minver

FROM scratch AS build
WORKDIR /usr/share
COPY --from=dotnetsdk3 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk5 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk6 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk6 /usr/share/powershell /usr/share/powershell
COPY --from=minver /usr/share/minver-cli /usr/share/minver-cli

FROM jetbrains/teamcity-agent:${TEAMCITYAGENT_IMAGE_TAG} AS final

USER root

ARG DOTNET_VERSION6=6.0.1
ARG DOTNET_VERSION5=5.0.13
ARG DOTNET_VERSION31=3.1.22
ARG DOTNET_SDK_VERSION6
ARG DOTNET_SDK_VERSION5
ARG DOTNET_SDK_VERSION31
ARG POWERSHELL_VERSION=7.2.1
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

COPY --from=build /usr/share /usr/share

RUN ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
  && chmod 755 /usr/share/powershell/pwsh \
  && ln -s /usr/share/minver-cli/minver /usr/bin/minver \
  && chmod 755 /usr/share/minver-cli/minver \
  # Install module Pester - for root user
  && pwsh -Command "Install-Module -Name Pester -Scope AllUsers -Force" \
  && dotnet nuget locals all --clear

USER buildagent

# ENV  PATH="$PATH:/home/buildagent/.dotnet/tools"
# RUN dotnet tool install --global minver-cli --version $DOTNET_MINVER_VERSION
