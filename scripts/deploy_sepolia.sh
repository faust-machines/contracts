#!/usr/bin/env bash

# Ensure the .env file exists
if [ ! -f .env ]; then
  echo "The .env file is missing. Please make sure it exists in the current directory."
  exit 1
fi

# Read the RPC URL
source .env

# Check if the PRIVATE_KEY and ADDRESS variables are set in the .env file
if [ -z "$SEPOLIA_PRIVATE_KEY" ] || [ -z "$SEPOLIA_DEPLOYER_ADDRESS" ]; then
  echo "The SEPOLIA_PRIVATE_KEY and SELPOLIA_DEPLOYER_ADDRESS must be set in the .env file."
  exit 1
fi

# Check if an argument is provided for the script path
if [ -z "$1" ]; then
  echo "No argument provided. Please provide a path for the script to deploy."
  exit 1
fi

# Read script
echo Which script do you want to run?
read script

# Read script arguments
echo Enter script arguments, or press enter if none:
read -ra args

# Run the script
echo Running Script: $script...

# Run the script with interactive inputs
forge script $script \
    --rpc-url $SEPOLIA_RPC_URL \
    --broadcast \
    -vvvv \
    --private-key $SEPOLIA_PRIVATE_KEY \
    $args
