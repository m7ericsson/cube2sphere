FROM node:14.15.1-stretch AS node
FROM sherrycherish/krpano:latest AS base

WORKDIR /usr/src/app

ENV YARN_VERSION 1.22.5
RUN mkdir -p /opt
COPY --from=node /opt/yarn-v$YARN_VERSION /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/
COPY --from=node /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
  && ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

RUN ln -s /app/krpano-1.19-pr12/krpanotools /usr/bin/krpanotools

COPY package*.json ./
RUN mkdir /tmp/images && chmod 777 -R /tmp/images

EXPOSE 8080
CMD [ "node", "server.js" ]

FROM base AS dev

RUN yarn global add nodemon
RUN yarn install
COPY . .

CMD [ "nodemon", "server.js" ]

FROM base AS prod

RUN yarn install --prod
COPY . .

CMD [ "node", "server.js" ]