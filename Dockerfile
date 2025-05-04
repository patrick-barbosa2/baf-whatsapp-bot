# Usamos a imagem WAHA como base
FROM devlikeapro/waha:latest-2025.4.1

# Instalar dependências para n8n
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g n8n@1.46.0

# Configurar diretórios para logs e persistência
RUN mkdir -p /app/logs /data/n8n /data/waha && \
    chmod -R 777 /app/logs /data/n8n /data/waha

# Copiar o script de inicialização
WORKDIR /app
COPY start.sh .
RUN chmod +x start.sh

# Variáveis de ambiente
ENV WAHA_API_KEY=123456
ENV WAHA_START_SESSION=whatsapp
ENV N8N_PORT=5678
ENV NODE_ENV=production
ENV N8N_PATH=/data/n8n
ENV N8N_HOST=0.0.0.0

# Expor portas
EXPOSE 3000 5678

# Comando de inicialização
CMD ["./start.sh"]