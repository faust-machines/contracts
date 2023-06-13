// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IRealityEvent {
    // data structures
    struct EventData {
        string facility_name;
        string sensor_name;
        uint256 weight_kg;
    }

    struct ROCInfo {
        string device_id;
        address roc_device_address;
        address roc_contract_address;
        uint256 latitude;
        uint256 longitude;
    }

    function mint(
        address to,
        uint256 tokenId,
        EventData memory _eventData,
        ROCInfo memory _rocInfo
    ) external;

    function getEventData(uint256 tokenId) external view returns (EventData memory);

    function getRocInfo(uint256 tokenId) external view returns (ROCInfo memory);
}

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
  IRealityEvent public realityEventContract;

  constructor() {
    owner = msg.sender;
  }

  function getRealityEventContractAddress() external view returns (address) {
    return address(realityEventContract);
  }

  function setRealityEventContractAddress(address newAddress) external {
    realityEventContract = IRealityEvent(newAddress);
  }

  function getProofEvent(bytes32 proofKey) external view returns (ProofEvent memory) {
    return proofEvents[proofKey];
  }

  function addProofEvent(string memory topicName, string memory fileName, string memory filePath, bytes32 newProof) external {
    proofEvents[newProof] = ProofEvent(topicName, fileName, filePath, newProof);
  }

  function addProofEvents(ProofEvent[] calldata events) external {
    for (uint i = 0; i < events.length; i++) {
      proofEvents[events[i].proof] = events[i];
    }
  }
}