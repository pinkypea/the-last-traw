FROM node:18-alpine

WORKDIR /app

COPY package.json /app/

COPY package-lock.json /app/

# Debugging step: List files in /app to ensure package*.json is present
RUN ls -la /app

RUN npm install

COPY . /app/

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]