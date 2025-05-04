# Dockerfile WAHA corrigido
FROM node:18

# Instala TypeScript globalmente
RUN npm install -g typescript

# Clona o projeto WAHA
RUN git clone https://github.com/devlikeapro/waha.git /app

# Define diretório
WORKDIR /app

# Força instalação ignorando conflitos de peer dependencies
RUN npm install --legacy-peer-deps

# Compila o projeto
RUN npm run build

# Expõe a porta padrão do WAHA
EXPOSE 3000

# Inicia o servidor
CMD ["node", "dist/main"]