FROM sawala/node-base:1.0 AS base
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .

FROM base AS build
ENV NODE_ENV=production
WORKDIR /build
COPY --from=base /app ./
RUN yarn build

FROM sawala/node-runner:1.0
ENV NODE_ENV=production
EXPOSE 3000
WORKDIR /app
COPY --from=build /build/next.config.js /build/package.json /build/.git ./
COPY --from=build /build/.next ./.next
COPY --from=build /build/public ./public
COPY --from=build /build/node_modules ./node_modules
CMD ["yarn", "start"]
