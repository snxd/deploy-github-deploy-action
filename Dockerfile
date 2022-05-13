FROM mcr.microsoft.com/dotnet/runtime:6.0-bullseye-slim

RUN apt-get update && \
    apt-get -y install python3.9 python3.9-distutils python3-pkg-resources python3-cffi-backend git wget python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY . /run
RUN chmod +x /run/entrypoint.sh

ENTRYPOINT [ "/run/entrypoint.sh" ]
