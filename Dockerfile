FROM bitwalker/alpine-erlang:latest

ADD ./_build/prod/rel/tz .

ENV PORT=4000

EXPOSE 4000

USER default

ENTRYPOINT [ "./bin/tz" ]
CMD [ "foreground" ]