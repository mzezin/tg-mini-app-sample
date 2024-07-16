FROM node:20-alpine AS base
ENV NODE_ENV=production YARN_VERSION=4.3.1

RUN apk update && apk upgrade && apk add --no-cache libc6-compat && apk add dumb-init
RUN corepack enable && corepack prepare yarn@${YARN_VERSION}


FROM base
WORKDIR /app

COPY . .
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn

RUN yarn install --immutable
RUN yarn build

EXPOSE 3000
ENV PORT 3000
CMD ["dumb-init","yarn","start:prod"]