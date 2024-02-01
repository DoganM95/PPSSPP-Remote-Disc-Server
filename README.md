# Intro

Provide PSP games from e.g. PC to smartphone wirelessly and load them using PPSSPP remote disc 

## Variants

- `nodejs`: Runs an http-server in a docker container, serving games. This is the most lightweight and **recommended** variant.

- `cmake`: Pulls the latest ppsspp from its repo, then compiles a linux version, puts it in a docker container and configures it to serve games.  

- `flathub`: Failure. Flathub didn't work as planned and gave weird errors while trying to get ppsspp from their repo. Discontinued and archived.  

## Setup

### Server (Docker)

- `<restart_type>` can be e.g. `always`, more types [here](https://docs.docker.com/config/containers/start-containers-automatically/)
- `<local_port>` should be the port to serve the app on
- `<local_dir>` the directory that holds the games, e.g. `C:\Users\User\Games\PSP\iso` 

#### Windows

```powershell
docker run `
    -d `
    --restart <restart_type> `
    --name doganm95-ppsspp-remote-disc-server `
    -p <local_port>:8300 `
    -v "<local_dir>:/var/isos/" `
    ghcr.io/doganm95/ppsspp-remote-disc-server
```

#### Linux

```shell
docker run \
    -d \
    --restart <restart_type> \
    --name doganm95-ppsspp-remote-disc-server \
    -p <local_port>:8300 \
    -v "<local_dir>:/var/isos/" \
    ghcr.io/doganm95/ppsspp-remote-disc-server
```

## Docker images

The docker images are based off the `nodejs` variant

- Active: [ghcr.io/doganm95/ppsspp-remote-disc-server:latest](https://github.com/DoganM95/PPSSPP-Remote-Disc-Server/pkgs/container/ppsspp-remote-disc-server)
- Legacy: [doganm95/ppsspp-remote-disc-server](https://hub.docker.com/r/doganm95/ppsspp-remote-disc-server)

## Credits

**unknownbrackets** : For the initial working nodejs example
