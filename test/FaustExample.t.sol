// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import {FaustExample} from "src/FaustExample.sol";

contract FaustExampleTest is Test {
    using stdStorage for StdStorage;

    FaustExample greeter;

    event GMEverybodyGM();

    function setUp() external {
        greeter = new FaustExample("gm");
    }

    // VM Cheatcodes can be found in ./lib/forge-std/src/Vm.sol
    // Or at https://github.com/foundry-rs/forge-std
    function testSetGm() external {
        // slither-disable-next-line reentrancy-events,reentrancy-benign
        greeter.setGreeting("gm gm");

        // Expect the GMEverybodyGM event to be fired
        vm.expectEmit(true, true, true, true);
        emit GMEverybodyGM();
        // slither-disable-next-line unused-return
        greeter.gm("gm gm");

        // Expect the gm() call to revert
        vm.expectRevert(abi.encodeWithSignature("BadGm()"));
        // slither-disable-next-line unused-return
        greeter.gm("gm");

        // We can read slots directly
        uint256 slot = stdstore.target(address(greeter)).sig(greeter.owner.selector).find();
        assertEq(slot, 1);
        bytes32 owner = vm.load(address(greeter), bytes32(slot));
        assertEq(address(this), address(uint160(uint256(owner))));
    }

    function testGetGm() external {
        // slither-disable-next-line unused-return
        greeter.setGreeting("1129911299112991129911299");
        assertEq(greeter.getGreeting(), "1129911299112991129911299");
    }
}
