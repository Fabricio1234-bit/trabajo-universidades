#Asegurece de estar en la ubicacion de la carpeta donde esta el Dockerfile para crear la imagen

# Comando para crear la imagen
docker build -f Dockerfile -t calculadora .

# Comando para crear el contenedor
docker run -d -p 8118:80 -p 2202:22 --name calculara calculadora 