// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from 'forge-std/Script.sol';

import {ROC} from "src/ROC.sol";

/// @notice A deployment script for RealityEvent, Notary, and ROC contracts
contract Deploy is Script {
  ROC public roc;

  /// @notice The main script entrypoint
  function run() external {
    vm.startBroadcast();

    roc = new ROC();

    vm.stopBroadcast();
  }
}






