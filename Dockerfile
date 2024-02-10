FROM node:latest

WORKDIR /usr/src/app

# Copiamos el archivo main.js de la máquina local al directorio de trabajo en la imagen
COPY main.js .

# Definimos el comando que se ejecutará cuando se inicie el contenedor
CMD ["node", "main.js"]