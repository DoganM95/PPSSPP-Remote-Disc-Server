# Use this file with caution!. Will kill and delete any existing container, then start ppsspp
docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker build -t doganm95/ppsspp-remote-disc-server .
docker run -p 8300:8300 -v "C:\Users\Dogan\OneDrive\Desktop\:/root/.config/ppsspp/PSP/GAME/" doganm95/ppsspp-remote-disc-server