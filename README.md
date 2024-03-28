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

### Client (Android/IOS)

- Open the app, click `Settings` -> `Tools` -> `Remote disc streaming`
- Click `Settings`, enable `manually configure client`
  - Set `Remote server` to the ip address of the server, e.g. `192.168.0.155`
  - Set `Remote port` to the respective port, e.g. `8300`
- Go back and click Browse games

Full documentation [here](https://www.ppsspp.org/docs/reference/disc-streaming/)

## Notes

- Browsing remote discs for the first time, it may only shows empty tiles first, while the games and their icons load. This happens every time, a new game is added and may take a minute, depending on your hardware. After that, the list will be cached and load immediately the next time (except a new game is added again)
- The ghcr image is based off the `nodejs` variant

## Credits

**unknownbrackets** : For the initial working nodejs example
