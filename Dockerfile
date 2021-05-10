FROM node:14

ENV NODE_ENV=production

WORKDIR /usr/src/app

COPY package.json ./app

RUN npm install

CMD [ "node", "index.js" ]
