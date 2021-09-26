FROM node:11
WORKDIR /code
COPY server.js /code/
COPY package.json /code/
RUN npm install
EXPOSE 4000
ENTRYPOINT ["node", "server.js"]

