FROM elixir:latest

WORKDIR /app

ENV MIX_ENV prod

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./

COPY config ./config
COPY lib ./lib
COPY input ./input

RUN \
  mix deps.get --only prod && \
  mix deps.compile

ARG network_url="https://api.testnet.velas.com"
ENV NETWORK_URL ${network_url}
ARG input_dir="./input"
ENV INPUT_DIR ${input_dir} 

CMD ["mix", "run", "--no-halt"]