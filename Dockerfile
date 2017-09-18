FROM erlang:20-alpine

# rebar3 needs git to fetch deps
RUN apk add --no-cache git

# Copy source
COPY . /opt/
WORKDIR /opt

# Install rebar3
ADD https://s3.amazonaws.com/rebar3/rebar3 /usr/local/bin/
RUN chmod +x /usr/local/bin/rebar3

# Build standalone release
RUN rebar3 as prod release -o /build


FROM alpine:3.6
# Erlang runtime deps (as in https://github.com/bitwalker/alpine-erlang)
RUN \
    # Add edge repos tagged so that we can selectively install edge packages
    echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk --no-cache upgrade && \
    apk add --no-cache pcre@edge && \
    apk add --no-cache \
      ca-certificates \
      openssl \
      ncurses \
      unixodbc \
      zlib && \
      update-ca-certificates --fresh

# Use release from prev. stage
COPY --from=0 /build/websocket_chat /app

ENV HOME=/app
WORKDIR "/app/bin"

EXPOSE 8080

ENTRYPOINT ["./websocket_chat"]
CMD ["foreground"]
