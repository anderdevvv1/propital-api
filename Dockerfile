# desarrollo
FROM node:18-alpine As development

WORKDIR /usr/src/app

COPY package*.json ./

# Instalar dependencias de desarrollo
RUN npm install

COPY . .

RUN npm run build

# producción
FROM node:18-alpine As production

WORKDIR /usr/src/app

COPY package*.json ./

# Instalar solo dependencias de producción y el CLI de NestJS globalmente
RUN npm install -g @nestjs/cli && \
    npm install --only=production

COPY . .

# Copiar los archivos compilados desde la etapa de desarrollo
COPY --from=development /usr/src/app/dist ./dist

EXPOSE 3000

CMD ["npm", "run", "start:prod"]