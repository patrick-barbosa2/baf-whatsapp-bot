FROM node:18

# Instalar n8n globalmente
RUN npm install -g n8n

# Criar diretório de trabalho
WORKDIR /app

# Expor porta padrão do n8n
EXPOSE 5678

# Rodar o n8n
CMD ["n8n"]
