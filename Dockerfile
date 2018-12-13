FROM bitwalker/alpine-elixir:latest as build

COPY . .

RUN export MIX_ENV=prod && \
  rm -Rf _build && \
  mix deps.get && \
  mix release

RUN APP_NAME="tz" && \
  RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
  mkdir /export && \
  tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export


FROM erlang:21-alpine

RUN apk add --no-cache bash

EXPOSE 4000
ENV REPLACE_OS_VARS=true \
  PORT=4000

COPY --from=build /export/ .

ENTRYPOINT ["./bin/tz"]
CMD ["foreground"]