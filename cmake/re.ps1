# Use this file with caution!. Will kill and delete any existing container, then start ppsspp
docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker build -t doganm95/ppsspp-remote-disc-server .
# docker run --read-only -d -p 8300:8300 -v "C:\Users\Dogan\OneDrive\Desktop\ppsspp server\iso:/var/isos" doganm95/ppsspp-remote-disc-server
# docker run --read-only -v "C:\Users\Dogan\OneDrive\Desktop\ppsspp server\iso:/var/isos" -p 8300:8300 -d doganm95/ppsspp-remote-disc-server
docker run -v "C:\Users\Dogan\OneDrive\Desktop\ppsspp server\iso:/var/isos" -p 8300:8300 doganm95/ppsspp-remote-disc-server