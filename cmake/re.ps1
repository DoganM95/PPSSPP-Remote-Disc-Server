docker kill $(docker ps -q)
docker build -t ppsspp .
docker run -p 8300:8300 -v "C:\Users\Dogan\OneDrive\Desktop\:/root/.config/ppsspp/PSP/GAME/" ppsspp