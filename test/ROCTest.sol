// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import {ROC} from "src/ROC.sol";
import {RealityEvent} from "src/RealityEvent.sol";

contract ROCTest is Test {
    ROC roc;
    RealityEvent eventContract;
    
    uint256 testNumber;

    function setUp() public {
        roc = new ROC();
        testNumber = 42;
    }

    function testROC() public {
        assertEq(testNumber, 42);
    }
}