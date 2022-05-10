# target: teslaconsulting/docker-compose:1.29.2
FROM debian:bullseye-20220418-slim AS build
WORKDIR /usr/local/bin
COPY docker-compose-Linux-x86_64 /usr/local/bin/docker-compose
RUN chmod 755 /usr/local/bin/docker-compose
ENTRYPOINT [ "docker-compose" ]
