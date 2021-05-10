FROM node:14

ENV NODE_ENV=production

WORKDIR /app

COPY package.json ./app

COPY . .

CMD [ "node", "index.js" ]
