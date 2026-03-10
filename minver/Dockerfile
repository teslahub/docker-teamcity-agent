FROM mcr.microsoft.com/dotnet/sdk:8.0

# Install minver Console global tool
ARG DOTNET_MINVER_VERSION=7.0.0
ARG DOTNET_MINVER_SHA512=d7a05f606a33b95f9c415f95fb3afb0af3915728e0a483ee1eb430b9ca160208712171b9741b7b7d5e40d9f1159d431789989fe598ba8047ed167d336cd357a2
ENV DOTNET_MINVER_VERSION=${DOTNET_MINVER_VERSION}

RUN curl -SL --output minver-cli.$DOTNET_MINVER_VERSION.nupkg https://globalcdn.nuget.org/packages/minver-cli.$DOTNET_MINVER_VERSION.nupkg \
  && echo "Echo hash: $(sha512sum minver-cli.$DOTNET_MINVER_VERSION.nupkg)" \
  && echo "$DOTNET_MINVER_SHA512  minver-cli.$DOTNET_MINVER_VERSION.nupkg" | sha512sum -c - \
  && mkdir -p /usr/share/minver-cli \
  && dotnet tool install --add-source / --tool-path /usr/share/minver-cli --version $DOTNET_MINVER_VERSION minver-cli \
  && rm minver-cli.$DOTNET_MINVER_VERSION.nupkg \
  && ln -s /usr/share/minver-cli/minver /usr/bin/minver \
  && chmod 755 /usr/share/minver-cli/minver \
  && find /usr/share/minver-cli -print | grep -i '.*[.]nupkg$' | xargs rm \
  && dotnet nuget locals all --clear \
  && minver --help
