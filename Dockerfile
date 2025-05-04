FROM node:18-slim

# Instalar dependências
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ffmpeg \
    chromium \
    && rm -rf /var/lib/apt/lists/*

# Configurar diretórios de trabalho
WORKDIR /app
RUN mkdir -p /app/logs /data/n8n /data/waha

# Instalar n8n
RUN npm install -g n8n@1.46.0

# Clonar WAHA do GitHub
RUN git clone https://github.com/devlikeapro/waha.git /app/waha
WORKDIR /app/waha
RUN npm install && \
    npm run build

# Voltar ao diretório de trabalho principal
WORKDIR /app

# Criar script de inicialização simples
RUN echo '#!/bin/bash\n\
echo "=== Iniciando Assistente Financeiro WhatsApp ==="\n\
\n\
# Iniciar WAHA\n\
echo "Iniciando WAHA API..."\n\
cd /app/waha\n\
node ./build/bin/start.js start --session=whatsapp > /app/logs/waha.log 2>&1 &\n\
\n\
# Aguardar inicialização\n\
echo "Aguardando inicialização (15s)..."\n\
sleep 15\n\
\n\
# Iniciar n8n\n\
echo "Iniciando n8n..."\n\
n8n start\n\
' > /app/start.sh

# Tornar o script executável
RUN chmod +x /app/start.sh

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
CMD ["/app/start.sh"]