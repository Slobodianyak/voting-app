FROM node:14

ENV NODE_ENV=production

WORKDIR /app

COPY package.json ./app

COPY . ./app

CMD [ "node", "index.js" ]
