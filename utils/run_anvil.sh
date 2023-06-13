#!/usr/bin/env bash

# Read the RPC URL
source .env

## Fork Mainnet
echo Please wait a few seconds for anvil to fork mainnet and run locally...
anvil --fork-url $RPC_URL &

# Wait for anvil to fork
sleep 5
