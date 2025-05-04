FROM node:18

# Instala TypeScript primeiro
RUN npm install -g typescript@5.3.3

# Instala n8n específico
RUN npm install -g n8n@1.46.0

# Instala WAHA
RUN npm install -g github:devlikeapro/waha

# Configurar diretórios e app
WORKDIR /app
COPY start.sh .
RUN chmod +x start.sh
RUN mkdir -p /app/logs

# Expõe portas
EXPOSE 3000 5678

CMD ["sh", "./start.sh"]