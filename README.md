### Build and run using shell script
* testnet
```bash
#!/bin/bash
export NETWORK_URL="https://api.testnet.velas.com"
export INPUT_DIR="./input_testnet"
export TIMEOUT_MS="5"
mix run --no-halt
```
* mainnet
```bash
#!/bin/bash
export NETWORK_URL="https://api.mainnet.velas.com"
export INPUT_DIR="./input_mainnet"
export TIMEOUT_MS="5"
mix run --no-halt
```

### Build and run using Docker
```bash
$ docker build \
    --build-arg network_url="https://api.mainnet.velas.com" \
    -t rename_me .
$ docker run -it \
    -p 0.0.0.0:6868:6868 \
    -p 0.0.0.0:9568:9568 \
    rename_me
```

### Example of metrics HTTP response body
```bash
# HELP network_health Last result of RPC health check
# TYPE network_health gauge
network_health 0
# HELP network_health_timestamp_seconds Last time RPC health check run
# TYPE network_health_timestamp_seconds gauge
network_health_timestamp_seconds 1665139329
# HELP network_alarms_total Total amount of unsuccessful RPC check runs
# TYPE network_alarms_total counter
network_alarms_total 1
```
