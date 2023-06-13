// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import {RealityEvent} from "src/RealityEvent.sol";

contract RealityEventTest is Test {
    RealityEvent realityEvent;
    uint256 testNumber;

    function setUp() public {
        realityEvent = new RealityEvent();
        testNumber = 42;
    }

    function testRealityEvent() public {
        assertEq(testNumber, 42);
    }
}