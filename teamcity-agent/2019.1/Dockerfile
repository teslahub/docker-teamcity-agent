FROM jetbrains/teamcity-agent:2019.1

# Cleanup previous sdk 2.2.103
RUN rm /usr/bin/dotnet && rm -rf /usr/share/dotnet

# from 3.0 bionic; https://github.com/dotnet/dotnet-docker/blob/master/3.0/sdk/bionic/amd64/Dockerfile
# jetbrains/teamcity-agent:2019.1 already have this below
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends \
#         libc6 \
#         libgcc1 \
#         libgssapi-krb5-2 \
#         libicu60 \
#         libssl1.1 \
#         libstdc++6 \
#         zlib1g \
#     && rm -rf /var/lib/apt/lists/*

# Install multi .NET Core SDK
ENV DOTNET_SDK_VERSION21=2.1.700 \
    DOTNET_SDK_VERSION22=2.2.300 \
    DOTNET_SDK_VERSION30=3.0.100-preview5-011568 \
    DOTNET_SDK_VERSION=3.0.100-preview5-011568 \
    # Configure web servers to bind to port 80 when present
    # ASPNETCORE_URLS=http://+:80 \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip

RUN curl -SL --output dotnet21.tar.gz https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION21/dotnet-sdk-$DOTNET_SDK_VERSION21-linux-x64.tar.gz \
    && dotnet_sha512='44258b4fb59927d9977900f0724eeb82248a3cc46ef3067088f8f78eb092c09da88bba9b7a488f1549a240e0dd3fea465ff1ffa6cdabb543b6bb536a12a549d3' \
    && echo "$dotnet_sha512 dotnet21.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet21.tar.gz -C /usr/share/dotnet \
    && rm dotnet21.tar.gz \
    # && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
    && curl -SL --output dotnet22.tar.gz https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION22/dotnet-sdk-$DOTNET_SDK_VERSION22-linux-x64.tar.gz \
    && dotnet_sha512='1d660a323180df3da8c6e0ea3f439d6bbec29670d498ac884f38bf3cdffbb041c7afff66171cdfd24c82394b845b135b057404def1fce9f206853726382bc42b' \
    && echo "$dotnet_sha512 dotnet22.tar.gz" | sha512sum -c - \
    # && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet22.tar.gz -C /usr/share/dotnet \
    && rm dotnet22.tar.gz \
    # && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
    && curl -SL --output dotnet30.tar.gz https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz \
    && dotnet_sha512='207af1f3161cbd0864902370475fcad5b500bf2b7199b06445e7c338053bc7cb0157ee1b4d00a37a351eae6e209417ee4a15eeacee086aac0ac1be7a62f3ad0b' \
    && echo "$dotnet_sha512 dotnet30.tar.gz" | sha512sum -c - \
    # && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet30.tar.gz -C /usr/share/dotnet \
    && rm dotnet30.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Trigger first run experience by running arbitrary cmd
#RUN dotnet help

# Install PowerShell global tool
ENV POWERSHELL_VERSION 6.2.0

RUN curl -SL --output PowerShell.Linux.x64.$POWERSHELL_VERSION.nupkg https://pwshtool.blob.core.windows.net/tool/$POWERSHELL_VERSION/PowerShell.Linux.x64.$POWERSHELL_VERSION.nupkg \
    && powershell_sha512='20b341fced6bc5b42d2eba0995a0877421ed22781f06a69699de2d507497ed217950831a9c9281eee73d78d5118be0adab30719aa959147b0fa6cc56655c2705' \
    && echo "$powershell_sha512  PowerShell.Linux.x64.$POWERSHELL_VERSION.nupkg" | sha512sum -c - \
    && mkdir -p /usr/share/powershell \
    && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $POWERSHELL_VERSION PowerShell.Linux.x64 \
    && rm PowerShell.Linux.x64.$POWERSHELL_VERSION.nupkg \
    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
    # To reduce image size, remove the copy nupkg that nuget keeps.
    && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm

# Install Coverlet Console global tool
ENV DOTNET_COVERLET_VERSION=1.5.1

RUN dotnet tool install --global coverlet.console --version 1.5.1

# Install SonarScanner for .Net Core 2.1 global tool
ENV DOTNET_SONARSCANNER_VERSION=4.6.2

RUN dotnet tool install --global dotnet-sonarscanner --version 4.6.2