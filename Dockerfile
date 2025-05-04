FROM node:18

# Instalar TypeScript (necessário) e WAHA via GitHub
RUN npm install -g typescript
RUN npm install -g github:devlikeapro/waha

# Criar diretório de trabalho
WORKDIR /app

# Expor porta padrão do WAHA
EXPOSE 3000

# Rodar WAHA
CMD ["npx", "waha"]