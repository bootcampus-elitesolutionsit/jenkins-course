FROM node:14-alpine

WORKDIR /usr/src/app/

COPY package*.json /usr/src/app/
COPY . /usr/src/app/

RUN npm install
RUN npm install vue-basic-alert

EXPOSE 8080
CMD ["npm", "run", "serve"]
