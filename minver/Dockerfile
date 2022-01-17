FROM mcr.microsoft.com/dotnet/sdk:6.0

# Install minver Console global tool
ARG DOTNET_MINVER_VERSION=3.0.0-rc.1
ENV DOTNET_MINVER_VERSION=${DOTNET_MINVER_VERSION}

RUN curl -SL --output minver-cli.$DOTNET_MINVER_VERSION.nupkg https://globalcdn.nuget.org/packages/minver-cli.$DOTNET_MINVER_VERSION.nupkg \
  && minver_cli_sha512='cd3740d459d2d6b2f049a1b201ed204dfc66ea73acdd21a7fd30bfaebf0158f61c6fdf67e839eba488c53d01990c58fae1c949ee4fc9a25edfeef29b45e1bbbd' \
  && echo "Echo hash: $(sha512sum minver-cli.$DOTNET_MINVER_VERSION.nupkg)" \
  && echo "$minver_cli_sha512  minver-cli.$DOTNET_MINVER_VERSION.nupkg" | sha512sum -c - \
  && mkdir -p /usr/share/minver-cli \
  && dotnet tool install --add-source / --tool-path /usr/share/minver-cli --version $DOTNET_MINVER_VERSION minver-cli \
  && rm minver-cli.$DOTNET_MINVER_VERSION.nupkg \
  && ln -s /usr/share/minver-cli/minver /usr/bin/minver \
  && chmod 755 /usr/share/minver-cli/minver \
  && find /usr/share/minver-cli -print | grep -i '.*[.]nupkg$' | xargs rm \
  && dotnet nuget locals all --clear
