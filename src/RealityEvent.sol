// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";

contract RealityEvent is ERC1155 {
    uint256 public constant REALITY_EVENT_TYPE = 1;

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

    // member variables 
    address public owner;
    mapping(uint256 => EventData) private events;
    mapping(uint256 => ROCInfo) private rocRegistry;

    // constructor
    constructor() ERC1155("") {
    }

    function mintRealityEvent(
        address to,
        uint256 tokenId,
        EventData memory _eventData,
        ROCInfo memory _rocInfo
    ) external {
        _mint(to, tokenId, 1, "");

        events[tokenId] = _eventData;
        rocRegistry[tokenId] = _rocInfo;
    }

    function geteventData(uint256 tokenId) public view returns (EventData memory) {
        return events[tokenId];
    }

    function getrocInfo(uint256 tokenId) public view returns (ROCInfo memory) {
        return rocRegistry[tokenId];
    }
}