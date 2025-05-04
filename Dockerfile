FROM node:18

WORKDIR /app

COPY . .

RUN npm install

EXPOSE 3000
EXPOSE 5678

CMD ["npm", "run", "start"]
