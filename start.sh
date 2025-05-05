#!/bin/bash

# Default fallback
: "${N8N_PORT:=5678}"
: "${N8N_WEBHOOK_URL:=http://localhost:$N8N_PORT}"

echo "✅ Iniciando n8n com URL: $N8N_WEBHOOK_URL"

# Executa o n8n com a URL correta
n8n start --tunnel --webhook-url "$N8N_WEBHOOK_URL" --port "$N8N_PORT"
