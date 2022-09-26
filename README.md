### Build and run using shell script
```bash
#!/bin/bash
export NETWORK_URL="https://api.testnet.velas.com"
export INPUT_DIR="./input"
mix run --no-halt
```

### Build and run using Docker
```bash
$ docker build -t rename_me .
$ docker run -it rename_me
```