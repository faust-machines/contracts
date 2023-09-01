// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from 'forge-std/Script.sol';

import {SimpleNFT} from "src/SimpleNFT.sol";

/// @notice A deployment script for RealityEvent, Notary, and ROC contracts
contract Deploy is Script {
  SimpleNFT public nft;

  /// @notice The main script entrypoint
  function run() external {
    vm.startBroadcast();

    nft = new SimpleNFT();

    vm.stopBroadcast();
  }
}






