# PPSSPP remote disc server

Provide PSP games from e.g. PC to smartphone wirelessly and load them using PPSSPP remote disc 

[![Docker Hub CD (Node.js)](https://github.com/DoganM95/PPSSPP-Remote-Disc-Server/actions/workflows/main.yml/badge.svg)](https://github.com/DoganM95/PPSSPP-Remote-Disc-Server/actions/workflows/main.yml)

## Variants

- `nodejs`: Runs an http-server in a docker container, serving games. This is the most lightweight and **recommended** variant.

- `cmake`: Pulls the latest ppsspp from its repo, then compiles a linux version, puts it in a docker container and configures it to serve games.  

- `flathub`: Failure. Flathub didn't work as planned and gave weird errors while trying to get ppsspp from their repo. Discontinued and archived.  

## Docker Image
[doganm95/ppsspp-remote-disc-server](https://hub.docker.com/r/doganm95/ppsspp-remote-disc-server)

## Credits

**unknownbrackets** : For the initial working nodejs example
