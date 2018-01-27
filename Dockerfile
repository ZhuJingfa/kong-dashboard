FROM node:8.6.0-alpine

COPY . /app
WORKDIR /app

ADD repositories /etc/apk/repositories

    # npm prune --production is broken on npm 5.3.0
    # See https://github.com/npm/npm/issues/17781
RUN buildDeps='libtool gcc g++ python make coreutils curl' \
    && apk --update upgrade && apk add $buildDeps \
    && npm install \
    && npm run build \
    && rm -rf node_modules/ \
    && npm install --production \
    && apk del --purge $buildDeps \
    && rm -rf /var/cache/apk/* /var/lib/apk/  /etc/apk/cache/ 
    

EXPOSE 8080

ENTRYPOINT ["./docker/entrypoint.sh"]
