# Stop and delete any running ppsspp-remote-disc-server container
docker ps -a --format "{{.Names}}" | Where-Object { $_ -like "*ppsspp-remote-disc-server*" } | ForEach-Object { docker stop $_; docker rm $_ }; 

# Delete any existing ppsspp-remote-disc-server docker images
docker images --format "{{.Repository}}:{{.Tag}}" | Where-Object { $_ -like "*ppsspp-remote-disc-server*" } | ForEach-Object { docker rmi $_ }

# Build the image locally from source
docker build -t ppsspp-remote-disc-server .

# Start a container
docker run `
    -d `
    --restart always `
    --name doganm95-ppsspp-remote-disc-server `
    -p 8300:8300 `
    -v "C:\Users\User\OneDrive\Desktop\iso:/var/isos/" `
    ppsspp-remote-disc-server
