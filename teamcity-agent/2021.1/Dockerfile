FROM jetbrains/teamcity-agent:2021.1-linux

USER root

# Install PowerShell global tool
# Install minver Console global tool
ENV DOTNET_VERSION31=3.1.15 \
  DOTNET_VERSION=5.0.7 \
  ASPNET_VERSION31=3.1.15 \
  ASPNET_VERSION=5.0.7 \
  DOTNET_SDK_VERSION31=3.1.409 \
  DOTNET_SDK_VERSION=5.0.301 \
  POWERSHELL_VERSION=7.1.3 \
  POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Ubuntu-20.04 \
  DOTNET_MINVER_VERSION=2.5.0

RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-x64.tar.gz \
  && dotnet_sha512='4c91122a69eeb1f840d78ded96930db77d0b2fcaed4c355223d7c45380630277b703fb07524a284f9c7cef008d964ee1ae63b17518713ff30b1b61d13e134c7a' \
  && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
  # && mkdir -p /dotnet \
  # && tar -ozxf dotnet.tar.gz -C /dotnet \
  && tar -ozxf dotnet.tar.gz -C /usr/share/dotnet \
  && rm dotnet.tar.gz \
  && curl -SL --output aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$ASPNET_VERSION/aspnetcore-runtime-$ASPNET_VERSION-linux-x64.tar.gz \
  && aspnetcore_sha512='03399412dfa6ec9b75125b38d7d4297e0cb8cb4ae37cfb27d6cc948942763691c61647d83c3a8a068291a389c35fc6a89d375c97253335c6a8985d55fcac8918' \
  && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
  && tar -ozxf aspnetcore.tar.gz -C /usr/share/dotnet/shared/Microsoft.AspNetCore.App \
  && rm aspnetcore.tar.gz \
  && curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz \
  && dotnet_sha512='81cd7a3550a262d5c907030677429fa9a1cb515071274931ab760bd8bb2a14f40c9384c8757e1c1aa681b1de22035f16bf20b41ed208becd054cc9bb1f620322' \
  && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
  # && mkdir -p /usr/share/dotnet \
  && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./packs ./sdk ./templates ./LICENSE.txt ./ThirdPartyNotices.txt \
  && rm dotnet.tar.gz \
  # Trigger first run experience by running arbitrary cmd
  && dotnet help \
  && curl -SL --output PowerShell.Linux.x64.$POWERSHELL_VERSION.nupkg https://pwshtool.blob.core.windows.net/tool/$POWERSHELL_VERSION/PowerShell.Linux.x64.$POWERSHELL_VERSION.nupkg \
  && powershell_sha512='537d885b79dd1cd183d14b5f5e71046558fb015f562bb817ee90fbabaa9b1039c822949b7e1a5c9b69a976eae09786e3b2c0f0586c01c822868cc48ea7e36620' \
  && echo "$powershell_sha512  PowerShell.Linux.x64.$POWERSHELL_VERSION.nupkg" | sha512sum -c - \
  && mkdir -p /usr/share/powershell \
  && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $POWERSHELL_VERSION PowerShell.Linux.x64 \
  && dotnet nuget locals all --clear \
  && rm PowerShell.Linux.x64.$POWERSHELL_VERSION.nupkg \
  && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
  && chmod 755 /usr/share/powershell/pwsh \
  # To reduce image size, remove the copy nupkg that nuget keeps.
  && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm \
  && curl -SL --output minver-cli.$DOTNET_MINVER_VERSION.nupkg https://globalcdn.nuget.org/packages/minver-cli.$DOTNET_MINVER_VERSION.nupkg \
  && minver_cli_sha512='ce186951a4296e10a82cf40aed53577b19fa63ed22fda5f239e5504d6f6a519e22f94619a6c5be0aeb319af67baf7f43426f60046fdc3ed014d7b46e25b611e4' \
  && echo "$minver_cli_sha512  minver-cli.$DOTNET_MINVER_VERSION.nupkg" | sha512sum -c - \
  && mkdir -p /usr/share/minver-cli \
  && dotnet tool install --add-source / --tool-path /usr/share/minver-cli --version $DOTNET_MINVER_VERSION minver-cli \
  && rm minver-cli.$DOTNET_MINVER_VERSION.nupkg \
  && ln -s /usr/share/minver-cli/minver /usr/bin/minver \
  && chmod 755 /usr/share/minver-cli/minver \
  && find /usr/share/minver-cli -print | grep -i '.*[.]nupkg$' | xargs rm \
  && dotnet nuget locals all --clear

USER buildagent

# ENV  PATH="$PATH:/home/buildagent/.dotnet/tools"
# RUN dotnet tool install --global minver-cli --version $DOTNET_MINVER_VERSION

# Install module Pester
RUN pwsh -Command "Install-Module -Name Pester -Force"