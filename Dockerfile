# desarrollo
FROM node:18-alpine As development

WORKDIR /usr/src/app

COPY package*.json ./

# Instalar dependencias de desarrollo y el CLI de NestJS
RUN npm install -g @nestjs/cli && \
    npm install

COPY . .

RUN npm run build

# producción
FROM node:18-alpine As production

WORKDIR /usr/src/app

COPY package*.json ./

# Instalar solo dependencias de producción
RUN npm ci --only=production

# Copiar los archivos compilados desde la etapa de desarrollo
COPY --from=development /usr/src/app/dist ./dist
COPY --from=development /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["npm", "run", "start:prod"]