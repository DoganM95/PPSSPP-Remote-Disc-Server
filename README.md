# Runs a PPSSPP remote disc server either in node.js or in a docker container

## Variants

- `nodejs`: Runs a (nodejs) http-server in a docker container, serving games (credit to unknownbrackets). This is the most lightweight and **recommended** variant.

- `cmake`: Pulls the latest ppsspp from its repo, then compiles a linux version, puts it in a docker container and configures it to serve games.  

- `flathub`: Failure. Flathub didn't work as planned and gave weird errors while trying to get ppsspp from their repo. Discontinued and archived.  

## Credits

**unknownbrackets** : For the initial working nodejs example
