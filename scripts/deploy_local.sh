#!/usr/bin/env bash

# Ensure the .env file exists
if [ ! -f .env ]; then
  echo "The .env file is missing. Please make sure it exists in the current directory."
  exit 1
fi

# Source the .env file to read the RPC URL, PRIVATE_KEY, and ADDRESS
source .env

# Check if the PRIVATE_KEY and ADDRESS variables are set in the .env file
if [ -z "$LOCAL_PRIVATE_KEY" ] || [ -z "$LOCAL_DEPLOYER_ADDRESS" ]; then
  echo "The PRIVATE_KEY and ADDRESS must be set in the .env file."
  exit 1
fi

# Check if an argument is provided for the script path
if [ -z "$1" ]; then
  echo "No argument provided. Please provide a path for the script to deploy."
  exit 1
fi

# Set script var to the first argument
script=$1

# Optionally, handle additional arguments for the script
args="${@:2}"

# Run the script with verbosity and provided arguments
echo "Running Script: $script..."
forge script $script \
    --fork-url $LOCAL_RPC_URL \
    --broadcast \
    -vvvv \
    --sender $LOCAL_DEPLOYER_ADDRESS \
    --private-key $LOCAL_PRIVATE_KEY \
    $args

# Setup trap handlers to clean up on exit or interruption
trap "exit" INT TERM
trap "kill 0" EXIT