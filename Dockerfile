# Containerzed Build

FROM bitwalker/alpine-elixir:1.7.4 as build

COPY . .

RUN export MIX_ENV=prod && \
  rm -Rf _build && \
  mix deps.get && \
  mix release

RUN APP_NAME="tz" && \
  RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
  mkdir /export && \
  tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export

# Production Image

FROM alpine:3.8

RUN apk add --no-cache bash openssl

ENV REPLACE_OS_VARS=true \
  PORT=4000

COPY --from=build /export/ .

EXPOSE 4000

ENTRYPOINT ["./bin/tz"]
CMD ["foreground"]