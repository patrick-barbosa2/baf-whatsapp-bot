#!/bin/bash
set -e

echo "Iniciando serviços..."

# Definir variáveis de ambiente caso não estejam definidas
export N8N_PORT=${N8N_PORT:-5678}
export WAHA_API_KEY=${WAHA_API_KEY:-123456}

echo "Verificando dependências..."
which tsc || { echo "TypeScript não instalado corretamente"; exit 1; }

echo "Iniciando WAHA em background..."
npx waha >> /app/logs/waha.log 2>&1 &
WAHA_PID=$!

echo "Aguardando WAHA inicializar (15s)..."
sleep 15

# Verificar se WAHA está respondendo
if ! ps -p $WAHA_PID > /dev/null; then
  echo "❌ WAHA falhou ao iniciar. Verificando logs:"
  tail -n 50 /app/logs/waha.log
  exit 1
fi

# Verificar API do WAHA
echo "Testando API do WAHA..."
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/sessions || {
  echo "❌ API do WAHA não está respondendo. Verificando logs:"
  tail -n 50 /app/logs/waha.log
  exit 1
}

echo "✅ WAHA iniciado com sucesso!"
echo "Iniciando n8n..."

# Iniciar n8n em foreground
n8n start