FROM mcr.microsoft.com/dotnet/sdk:3.1

# Install minver Console global tool
ENV DOTNET_MINVER_VERSION=2.5.0

RUN curl -SL --output minver-cli.$DOTNET_MINVER_VERSION.nupkg https://globalcdn.nuget.org/packages/minver-cli.$DOTNET_MINVER_VERSION.nupkg \
  && minver_cli_sha512='ce186951a4296e10a82cf40aed53577b19fa63ed22fda5f239e5504d6f6a519e22f94619a6c5be0aeb319af67baf7f43426f60046fdc3ed014d7b46e25b611e4' \
  && echo "$minver_cli_sha512  minver-cli.$DOTNET_MINVER_VERSION.nupkg" | sha512sum -c - \
  && mkdir -p /usr/share/minver-cli \
  && dotnet tool install --add-source / --tool-path /usr/share/minver-cli --version $DOTNET_MINVER_VERSION minver-cli \
  && rm minver-cli.$DOTNET_MINVER_VERSION.nupkg \
  && ln -s /usr/share/minver-cli/minver /usr/bin/minver \
  && chmod 755 /usr/share/minver-cli/minver \
  && find /usr/share/minver-cli -print | grep -i '.*[.]nupkg$' | xargs rm \
  && dotnet nuget locals all --clear
