FROM node:20-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
ENV COREPACK_DEFAULT_TO_LATEST=0
RUN corepack enable
# RUN npm install -g pnpm
COPY . /app
WORKDIR /app

FROM base AS build
WORKDIR /app
COPY package.json ./
COPY pnpm-lock.yaml ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
RUN pnpm run build admin

FROM base
COPY --from=build /app/dist /app/dist
COPY package.json pnpm-lock.yaml ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile
COPY --from=build /app/config/* ./config/
EXPOSE 8080
CMD ["node", "dist/apps/admin/src/main"]

