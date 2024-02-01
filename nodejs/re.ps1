# Use this file with caution!. Will kill and delete any existing container, then start ppsspp
docker ps -a --format "{{.Names}}" | Where-Object { $_ -like "*ppsspp-remote-disc-server*" } | ForEach-Object { docker stop $_ }

# Delete any existing rds docker images
docker ps -a --format "{{.Names}}" | Where-Object { $_ -like "*ppsspp-remote-disc-server*" } | ForEach-Object { docker stop $_; docker rm $_ }; docker images --format "{{.Repository}}:{{.Tag}}" | Where-Object { $_ -like "*ppsspp-remote-disc-server*" } | ForEach-Object { docker rmi $_ }

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