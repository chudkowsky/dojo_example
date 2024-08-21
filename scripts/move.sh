#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export RPC_URL="http://localhost:5050";

# export WORLD_ADDRESS=$(cat ./manifests/dev/manifest.json | jq -r '.world.address')

# sozo execute --world <WORLD_ADDRESS> <CONTRACT> <ENTRYPOINT>
sozo execute --world 0x403b5f047b8c4797139e30801e310473d99ca6877d19e0f27506f353f8f70f7 dojo_starter::systems::actions::actions move -c 1 --wait
