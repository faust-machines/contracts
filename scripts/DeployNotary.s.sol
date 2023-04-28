// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from 'forge-std/Script.sol';

import {Notary} from "src/Notary.sol";

/// @notice A very simple deployment script
contract Deploy is Script {

  /// @notice The main script entrypoint
  function run() external returns (Notary n) {
    vm.startBroadcast();
    n = new Notary();
    vm.stopBroadcast();
  }
}