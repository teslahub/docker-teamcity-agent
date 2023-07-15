FROM mcr.microsoft.com/dotnet/sdk:6.0

# Install minver Console global tool
ARG DOTNET_MINVER_VERSION=4.3.0
ARG DOTNET_MINVER_SHA512=90e851ccee7ec6249b0ba48221646a7d43b938fa074e3da7a22470ab0ea548d5c7e2a8b8628f3204d9ddf163f5c16f2b804d21f50165dc7e20848f155e288c0e
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
