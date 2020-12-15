FROM prooph/composer:7.2 -1x

RUN apk add --no-cache git
RUN apk add --no-cache patch

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
