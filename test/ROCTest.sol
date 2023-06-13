// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import {ROC} from "src/ROC.sol";

contract ROCTest is Test {
    ROC roc;
    uint256 testNumber;

    function setUp() public {
        roc = new ROC();
        testNumber = 42;
    }

    function testROCFunction() public {
        assertEq(testNumber, 42);
    }
}