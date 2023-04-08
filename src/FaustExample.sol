// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { ERC20 } from "solmate/tokens/ERC20.sol";

/// @title FaustExample
contract FaustExample {
  string public greeting;
  address public owner;

  // CUSTOMS
  error BadGm();
  event GMEverybodyGM();

  constructor(string memory newGreeting) {
    greeting = newGreeting;
    owner = msg.sender;
  }

  function gm(string memory myGm) external returns(string memory greet) {
    if (keccak256(abi.encodePacked((myGm))) != keccak256(abi.encodePacked((greet = greeting)))) revert BadGm();
    emit GMEverybodyGM();
  }

  function getGreeting() external view returns (string memory) {
    return greeting;
  }

  function setGreeting(string memory newGreeting) external {
    greeting = newGreeting;
  }
}
