FROM node:18

# Instala dependências
RUN npm install -g typescript n8n devlikeapro/waha

# Copia app e define ponto de entrada
WORKDIR /app
COPY start.sh .
RUN chmod +x start.sh

CMD ["sh", "./start.sh"]
