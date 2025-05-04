FROM node:18

RUN npm install -g n8n devlikeapro/waha

WORKDIR /app

COPY start.sh .

RUN chmod +x start.sh

EXPOSE 3000 5678

CMD ["./start.sh"]
