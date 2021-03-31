# PPSSPP-Remote-Disc-Server
Runs a PPSSPP instance in a docker container, serving remote discs.
This software is experimental.

## Variants

- `cmake`: Pulls the latest ppsspp from its repo, then compiles a linux version, puts it in a docker container and configures it to serve games.  

- `flathub`: Failure. Flathub didn't work as planned and gave weird errors while trying to get ppsspp from their repo. Discontinued and archived.  

## Outlook

This project can be considered an experiment and should not be taken seriously. It worked as planned and successfully streamed games to my laptop && smartphone from  

1. my other computer
2. my Synology NAS (takes a while to boot there, possibly because of its weak processor).

Nevertheless there might follow a much more lightweight variant, which only serves the games in a http server and needs much less resources, if i find enough spare time or this project is even used by others.  
