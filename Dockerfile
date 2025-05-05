FROM node:18

# Instala o n8n
RUN npm install -g n8n

# Cria diretório de trabalho
WORKDIR /app

# Copia o script de start
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Porta default do n8n
EXPOSE 5678

# Usa script como entrada
CMD ["/start.sh"]
