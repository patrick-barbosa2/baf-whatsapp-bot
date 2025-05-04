FROM node:18

# Instalar dependências globais necessárias
RUN npm install -g typescript

# Clonar o WAHA
RUN git clone https://github.com/devlikeapro/waha.git /app
WORKDIR /app

# Instalar dependências e compilar
RUN npm install
RUN npm run build

# Expor porta padrão
EXPOSE 3000

# Rodar app compilado
CMD ["node", "dist/main"]
