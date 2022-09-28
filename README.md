### Build and run using shell script
* testnet
```bash
#!/bin/bash
export NETWORK_URL="https://api.testnet.velas.com"
export INPUT_DIR="./input_testnet"
mix run --no-halt
```
* mainnet
```bash
#!/bin/bash
export NETWORK_URL="https://api.mainnet.velas.com"
export INPUT_DIR="./input_mainnet"
mix run --no-halt
```

### Build and run using Docker
```bash
$ docker build \
    --build-arg network_url="https://api.mainnet.velas.com" \
    -t rename_me .
$ docker run -it -p 0.0.0.0:6868:6868 rename_me
```
