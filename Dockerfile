FROM hexpm/elixir:1.11.4-erlang-24.0.4-ubuntu-groovy-20210325

RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get install -y inotify-tools && \
    apt-get install -y nodejs && \
    curl -L https://npmjs.org/install.sh | sh

RUN mix local.hex --force && \
    mix archive.install hex phx_new 1.5.1 --force && \
    mix local.rebar --force

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get
RUN mix deps.compile

# build project
COPY priv priv
COPY lib lib
RUN mix compile

RUN mkdir /app
COPY . /app
WORKDIR /app

CMD ["mix", "phx.server"]
