FROM node:18-alpine

WORKDIR /app

RUN ls -la /app

COPY ./frontend/package.json /app/

COPY ./frontend/package-lock.json /app/

RUN ls -la /app

RUN npm install

COPY ./frontend/. /app/

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]