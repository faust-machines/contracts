// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Verifier} from "src/Verifier.sol";

contract DeployVerifier is Script {
    Verifier public verifier;

    function run() external {
        vm.startBroadcast();

        verifier = new Verifier();

        vm.stopBroadcast();

        // Optional: Log the deployed contract address
        console.log("Verifier deployed at:", address(verifier));
    }
}