ARG DOTNET_SDK_VERSION5=5.0.301
ARG MINVER_IMAGE_TAG=2.5.0
ARG MINVER_IMAGE=teslaconsulting/minver-cli:$MINVER_IMAGE_TAG

FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION5}-focal AS dotnetsdk5
FROM $MINVER_IMAGE AS minver
FROM jetbrains/teamcity-agent:2021.1.1-linux AS final

USER root

ARG DOTNET_VERSION31=3.1.15
ARG DOTNET_SDK_VERSION31=3.1.409
ARG DOTNET_VERSION=5.0.7
ARG DOTNET_SDK_VERSION5
ARG POWERSHELL_VERSION=7.1.3
ARG MINVER_IMAGE_TAG
# Install PowerShell global tool
# Install minver Console global tool
ENV DOTNET_VERSION31=${DOTNET_VERSION31} \
  ASPNET_VERSION31=${DOTNET_VERSION31} \
  DOTNET_SDK_VERSION31=${DOTNET_SDK_VERSION31} \
  DOTNET_VERSION=${DOTNET_VERSION} \
  ASPNET_VERSION=${DOTNET_VERSION} \
  DOTNET_SDK_VERSION=${DOTNET_SDK_VERSION5} \
  POWERSHELL_VERSION=${POWERSHELL_VERSION} \
  POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Ubuntu-20.04 \
  DOTNET_MINVER_VERSION=$MINVER_IMAGE_TAG

COPY --from=dotnetsdk5 /usr/share/dotnet /usr/share/dotnet
COPY --from=dotnetsdk5 /usr/share/powershell /usr/share/powershell
COPY --from=minver /usr/share/minver-cli /usr/share/minver-cli

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
