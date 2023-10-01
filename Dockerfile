ARG BASE_IMG=windows/nanoserver
ARG CONT_VER=ltsc2022
FROM mcr.microsoft.com/${BASE_IMG}:${CONT_VER}
ARG NODE_VER=20.8.0

USER ContainerAdministrator
RUN curl.exe https://nodejs.org/dist/v%NODE_VER%/node-v%NODE_VER%-win-x64.zip -o C:\\node.zip & \
    tar -xf node.zip & del node.zip & \
    setx /M PATH "%PATH%;C:\\node-v%NODE_VER%-win-x64"

USER ContainerUser
WORKDIR C:\\Users\\ContainerUser\\

ENTRYPOINT ["node"]
