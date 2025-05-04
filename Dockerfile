# Usar a imagem oficial do WAHA como base
FROM devlikeapro/waha:latest

# Instalar n8n
RUN npm install -g n8n@1.46.0

# Criar script de inicialização para ambiente Koyeb
RUN echo '#!/bin/bash\n\
echo "=== Iniciando Assistente Financeiro WhatsApp no Koyeb ==="\n\
\n\
# Iniciar WAHA em background (a imagem oficial do WAHA não inicia automaticamente no Koyeb)\n\
echo "Iniciando WAHA API..."\n\
cd /app && node build/bin/start.js start --session=whatsapp > /app/waha.log 2>&1 &\n\
\n\
# Aguardar WAHA inicializar\n\
echo "Aguardando WAHA inicializar (15s)..."\n\
sleep 15\n\
\n\
# Iniciar n8n em foreground (necessário para o Koyeb)\n\
echo "Iniciando n8n..."\n\
n8n start\n\
' > /app/koyeb-start.sh

# Tornar o script executável
RUN chmod +x /app/koyeb-start.sh

# Variáveis de ambiente
ENV WAHA_API_KEY=123456
ENV N8N_PORT=5678
ENV NODE_ENV=production
ENV N8N_HOST=0.0.0.0

# Expor portas - o Koyeb exporá estas portas automaticamente
EXPOSE 3000 5678

# Comando de inicialização específico para Koyeb
CMD ["/app/koyeb-start.sh"]