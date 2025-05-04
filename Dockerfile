FROM node:18

# Atualiza npm para evitar warns
RUN npm install -g npm@11.3.0

# Instala dependências em passos separados para melhor caching e debug
RUN npm install -g typescript@5.3.3
RUN npm install -g n8n@1.46.0

# Instala WAHA com verificação explícita de typescript
RUN npm install -g typescript && \
    which tsc && \
    npm install -g github:devlikeapro/waha

# Cria diretórios de logs e garante permissões
RUN mkdir -p /app/logs /tmp/n8n /tmp/waha && \
    chmod -R 777 /app/logs /tmp/n8n /tmp/waha

# Copia app e define ponto de entrada
WORKDIR /app
COPY start.sh .
RUN chmod +x start.sh

# Configuração de ambiente para n8n e waha
ENV N8N_PORT=5678
ENV WAHA_API_KEY=123456

# Expõe portas
EXPOSE 3000 5678

CMD ["sh", "./start.sh"]