#!/usr/bin/env bash

# Read the RPC URL
source .env

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "No argument provided. Please provide an path for script to deploy."
  exit 1
fi

# set script var
script=$1

# Run the script
echo Running Script: $script...

# We specify the anvil url as http://localhost:8545
# We need to specify the sender for our local anvil node
forge script $script \
    --fork-url http://localhost:8545 \
    --broadcast \
    -vvvv \
    --sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    $args

# Once finished, we want to kill our anvil instance running in the background
trap "exit" INT TERM
trap "kill 0" EXIT
