#!/bin/bash
set -e

# Configurações e variáveis
export WAHA_API_KEY=${WAHA_API_KEY:-123456}
export N8N_PORT=${N8N_PORT:-5678}

echo "=== Iniciando Assistente Financeiro WhatsApp ==="

# Iniciar WAHA em background (usando script já presente na imagem)
echo "Iniciando WAHA API..."
cd /usr/src/waha
node ./build/bin/start.js start --session=whatsapp > /app/logs/waha.log 2>&1 &
WAHA_PID=$!

# Aguardar WAHA inicializar
echo "Aguardando WAHA inicializar (10s)..."
sleep 10

# Verificar se WAHA está rodando
if ! ps -p $WAHA_PID > /dev/null; then
  echo "❌ WAHA falhou ao iniciar. Log:"
  cat /app/logs/waha.log
  exit 1
fi

# Testar API do WAHA
echo "Testando API do WAHA..."
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/sessions || {
  echo "❌ API do WAHA não está respondendo!"
  exit 1
}

echo "✅ WAHA inicializado com sucesso na porta 3000"

# Iniciar n8n em foreground
echo "Iniciando n8n na porta $N8N_PORT..."
n8n start