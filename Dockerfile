
# Stage 1: Build Stage
FROM node:20-slim AS builder

WORKDIR /app

# Instalar pnpm
RUN npm install -g pnpm

# Copiar arquivos de dependência e instalar
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# Copiar o restante do código-fonte
COPY . .

# Compilar TypeScript
RUN pnpm exec tsc

# Stage 2: Production Stage
FROM node:20-slim AS production

WORKDIR /app

# Instalar pnpm
RUN npm install -g pnpm

# Copiar arquivos de dependência e instalar apenas dependências de produção
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile --prod

# Copiar o código compilado do estágio de build
COPY --from=builder /app/dist ./dist

# Expor a porta
EXPOSE 3004

# Comando para iniciar o serviço
CMD ["node", "dist/index.js"]
