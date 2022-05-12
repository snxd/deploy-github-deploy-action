FROM alpine:latest

RUN apk update && apk add bash ca-certificates wget

COPY . /run

ENTRYPOINT [ "/run/entrypoint.sh" ]
