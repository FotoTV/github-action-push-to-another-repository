FROM prooph/composer:7.2

RUN apk add --no-cache git
RUN apk add --no-cache patch

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
