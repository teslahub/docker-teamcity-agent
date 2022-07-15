FROM mcr.microsoft.com/dotnet/sdk:6.0

# Install minver Console global tool
ARG DOTNET_MINVER_VERSION=4.1.0
ENV DOTNET_MINVER_VERSION=${DOTNET_MINVER_VERSION}

RUN curl -SL --output minver-cli.$DOTNET_MINVER_VERSION.nupkg https://globalcdn.nuget.org/packages/minver-cli.$DOTNET_MINVER_VERSION.nupkg \
  && minver_cli_sha512='38f3a13b094e847b73f68965f68c907b9fcb9204eb26663b2f11ec03022d052b61d27827f1ccb51448825a639772dcb39cd6a0a8eb898c75b7fcb6c8168a690b' \
  && echo "Echo hash: $(sha512sum minver-cli.$DOTNET_MINVER_VERSION.nupkg)" \
  && echo "$minver_cli_sha512  minver-cli.$DOTNET_MINVER_VERSION.nupkg" | sha512sum -c - \
  && mkdir -p /usr/share/minver-cli \
  && dotnet tool install --add-source / --tool-path /usr/share/minver-cli --version $DOTNET_MINVER_VERSION minver-cli \
  && rm minver-cli.$DOTNET_MINVER_VERSION.nupkg \
  && ln -s /usr/share/minver-cli/minver /usr/bin/minver \
  && chmod 755 /usr/share/minver-cli/minver \
  && find /usr/share/minver-cli -print | grep -i '.*[.]nupkg$' | xargs rm \
  && dotnet nuget locals all --clear
