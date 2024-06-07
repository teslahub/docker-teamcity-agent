FROM mcr.microsoft.com/dotnet/sdk:6.0

# Install minver Console global tool
ARG DOTNET_MINVER_VERSION=5.0.0
ARG DOTNET_MINVER_SHA512=d4c1c25a51ac330574e6d95aa3cab88a47175ec0953a5a5fdac81d281664e7abdebf067834af6b368f5f6b7307ac1d1ebcda32b4fad017222899e78a5dac2064
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
