// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title ROC 
contract ROC {
  struct ProofEvent {
    string topicName;
    string fileName;
    string filePath;
    bytes32 proof;
  }

  mapping(bytes32 => ProofEvent) public proofEvents;
  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function getProofEvent(bytes32 proofKey) external view returns (ProofEvent memory) {
    return proofEvents[proofKey];
  }

  function addProofEvent(string memory fileName, string memory filePath, bytes32 newProof) external {
    proofEvents[newProof] = ProofEvent(fileName, filePath, newProof);
  }

  function addProofEvents(ProofEvent[] calldata events) external {
    for (uint i = 0; i < events.length; i++) {
      proofEvents[events[i].proof] = events[i];
    }
  }
}