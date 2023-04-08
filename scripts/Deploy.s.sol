// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from 'forge-std/Script.sol';

import {FaustExample} from "src/FaustExample.sol";

/// @notice A very simple deployment script
contract Deploy is Script {

  /// @notice The main script entrypoint
  function run() external returns (FaustExample example) {
    vm.startBroadcast();
    example = new FaustExample("GM");
    vm.stopBroadcast();
  }
}