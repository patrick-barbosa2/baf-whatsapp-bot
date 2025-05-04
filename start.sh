#!/bin/bash
set -e

# Seção de diagnóstico para identificar a estrutura da imagem
echo "=== Explorando estrutura de diretórios ==="
ls -la /
ls -la /usr/src/ 2>/dev/null || echo "Diretório /usr/src/ não existe"
ls -la /app 2>/dev/null || echo "Diretório /app não existe"
echo "Buscando arquivo start.js do WAHA:"
find / -name "start.js" -path "*/build/bin/*" 2>/dev/null || echo "Nenhum arquivo start.js encontrado"

# Configurações e variáveis
export WAHA_API_KEY=${WAHA_API_KEY:-123456}
export N8N_PORT=${N8N_PORT:-5678}

echo "=== Iniciando Assistente Financeiro WhatsApp ==="

# Encontrar o local correto do WAHA
echo "Procurando WAHA na imagem..."
if [ -d "/app" ] && [ -f "/app/build/bin/start.js" ]; then
    echo "WAHA encontrado no diretório /app"
    cd /app
    node ./build/bin/start.js start --session=whatsapp > /app/logs/waha.log 2>&1 &
elif [ -d "/usr/src/app" ] && [ -f "/usr/src/app/build/bin/start.js" ]; then
    echo "WAHA encontrado em /usr/src/app"
    cd /usr/src/app
    node ./build/bin/start.js start --session=whatsapp > /app/logs/waha.log 2>&1 &
else
    # Busca recursiva pelo arquivo de inicialização
    WAHA_PATH=$(find / -name "start.js" -path "*/build/bin/*" 2>/dev/null | head -1)
    if [ -n "$WAHA_PATH" ]; then
        WAHA_DIR=$(dirname "$WAHA_PATH")
        echo "WAHA encontrado em: $WAHA_DIR"
        node $WAHA_PATH start --session=whatsapp > /app/logs/waha.log 2>&1 &
    else
        echo "❌ WAHA não encontrado na imagem!"
        echo "Verificando alternativas..."
        
        if command -v waha &> /dev/null; then
            echo "Comando 'waha' encontrado, tentando iniciar diretamente..."
            waha start --session=whatsapp > /app/logs/waha.log 2>&1 &
        else
            echo "❌ Nenhuma instalação do WAHA encontrada! Iniciando apenas o n8n..."
        fi
    fi
fi

WAHA_PID=$!

# Aguardar momento para inicializar e verificar se WAHA está rodando
echo "Aguardando inicialização (15s)..."
sleep 15

# Verificar se o WAHA está rodando
if ps -p $WAHA_PID > /dev/null 2>&1; then
    echo "✅ WAHA iniciado com sucesso (PID: $WAHA_PID)"
    
    # Teste de API opcional
    echo "Testando API do WAHA..."
    curl -s http://localhost:3000/api/sessions || echo "❌ API do WAHA não está respondendo ainda"
else
    echo "⚠️ WAHA parece não estar rodando! Verificando logs:"
    cat /app/logs/waha.log || echo "Log não disponível"
fi

# Iniciando n8n em foreground
echo "Iniciando n8n na porta $N8N_PORT..."
n8n start