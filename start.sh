#!/bin/bash

echo "Iniciando WAHA e n8n..."

# Iniciar WAHA em background e redirecionar o log para debug
npx waha &> /tmp/waha.log &
WAHA_PID=$!

# Aguarda alguns segundos para garantir que WAHA esteja subindo
sleep 5

# Checar se WAHA ainda está rodando
if ! ps -p $WAHA_PID > /dev/null; then
  echo "❌ WAHA falhou ao iniciar. Verifique os logs em /tmp/waha.log"
  cat /tmp/waha.log
  exit 1
fi

# Iniciar n8n em foreground
n8n
