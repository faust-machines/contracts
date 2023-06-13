// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from 'forge-std/Script.sol';

import {RealityEvent} from "src/RealityEvent.sol";
import {ROC} from "src/ROC.sol";

/// @notice A deployment script for RealityEvent, Notary, and ROC contracts
contract Deploy is Script {
  RealityEvent public realityEvent;
  ROC public roc;

  /// @notice The main script entrypoint
  function run() external {
    vm.startBroadcast();

    realityEvent = new RealityEvent();
    notary = new Notary();
    roc = new ROC();

    vm.stopBroadcast();
  }
}






