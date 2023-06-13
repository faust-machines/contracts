// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from 'forge-std/Script.sol';

import {RealityEvent} from "src/RealityEvent.sol";

/// @notice A deployment script for RealityEvent, Notary, and ROC contracts
contract Deploy is Script {
  RealityEvent public realityEvent;

  /// @notice The main script entrypoint
  function run() external {
    vm.startBroadcast();

    realityEvent = new RealityEvent();

    vm.stopBroadcast();
  }
}





