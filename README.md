# Node.js on Nano Server

<p align=center><img src="https://github.com/Amitie10g/node-nanoserver-docker/assets/2096562/d2ac73e9-d71d-47a7-988a-d73358c411cc" alt="Node.js logo" style="text-align:center;margin:auto"></p>

This is an attemp to bring [Node](https://nodejs.org/) on [Windows Nano Server](https://hub.docker.com/_/microsoft-windows-nanoserver) (and optionally [PowerShell](https://hub.docker.com/_/microsoft-powershell) 7.3 on Nano Server) base image. Only the latest versions of Windows (ltsc2022, see below) and the latest minor version of every major version of Node.JS (from 4 to 20) are available. [[Dockerfile](https://github.com/Amitie10g/node-nanoserver-docker/blob/main/Dockerfile)]

## Tags

* ``<node version>`` Windows Nano Server ltsc2022 base image
* ``<node version>-pwsh`` Windows Nano Server ltsc2022 plus PowerShell 7.3 base image

## Usage

This project is intended to be used as base image for other Node-based projects. An example Dockerfile:

    FROM amitie10g/node-nanoserver
    
    COPY . "C:\Users\ContainerUser\app"
    WORKDIR "C:\Users\ContainerUser\app"
    RUN npm install --omit=dev
    
    ENTRYPOINT ["npm", "start"]

If you need to install system-wide software, you need to set `USER` as `ContainerAdministrator`

## Building

    docker build $TAGS --build-arg NODE_VER=<node version> --build-arg BASE_IMG=<base image> --build-arg CONT_VER=<container version> .
Where,

* ``NODE_VER`` is used to download Node from ``https://nodejs.org/dist/v${NODE_VER}/node-v${NODE_VER}-win-x64.zip``
* ``BASE_IMG`` is the base image, either ``windows/nanoserver`` or ``powershell``
* ``CONT_VER`` is the tag available for each base image. For a full list of available tags, consult the respective page of the base images provided (links above).

Don't use ``1809`` or ``ltsc2019`` due there are issues when appending a directory to PATH

`build.ps1` is provided for bulk building every Node versions available.

## Licensing

* Everything in this repo is released into the Public domain (the Unlicense)
*  **Node** is licensed under the **[MIT License](https://opensource.org/license/mit/)**.
* **Microsoft Windows container images** usage is subjected to the **[Microsoft EULA](https://learn.microsoft.com/en-us/virtualization/windowscontainers/images-eula)**
*  **Microsoft PowerShell** is licensed under the **MIT License**.
