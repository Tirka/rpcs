FROM elixir:latest

WORKDIR /app

ENV MIX_ENV prod

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./

COPY config ./config
COPY lib ./lib
COPY eex ./eex

# FIXME: copy only one dir
# COPY input_testnet ./input_testnet
COPY input_mainnet ./input_mainnet

RUN \
  mix deps.get --only prod && \
  mix deps.compile

ARG network_url="https://api.mainnet.velas.com"
ENV NETWORK_URL ${network_url}
ARG input_dir="./input_mainnet"
ENV INPUT_DIR ${input_dir}

EXPOSE 6868

CMD ["mix", "run", "--no-halt"]
