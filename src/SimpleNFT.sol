// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract SimpleNFT is ERC721, Ownable {
    uint256 private tokenIdCounter = 1;
    mapping(uint256 => string) private tokenIdToName;
    
    // Define a struct to hold the proof and topic together
    struct Proof {
        string proof;
        string topicName;
    }

    // Event to be emitted when a proof is added
    event ProofAdded(uint256 index, string proof, string topicName);

    // An array to store all proofs
    Proof[] private proofs;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) Ownable(msg.sender) {}

    function _exists(uint256 tokenId) internal view returns (bool) {
        try this.ownerOf(tokenId) returns (address) {
            return true;
        } catch {
            return false;
        }
    }

    function mintNFT(string memory _name) public onlyOwner {
        uint256 newTokenId = tokenIdCounter;
        tokenIdCounter++;

        tokenIdToName[newTokenId] = _name;
        _mint(msg.sender, newTokenId);
    }

    function setTokenName(uint256 _tokenId, string memory _name) public onlyOwner {
        require(_exists(_tokenId), "Token does not exist");
        tokenIdToName[_tokenId] = _name;
    }

    function getTokenName(uint256 _tokenId) public view returns (string memory) {
        require(_exists(_tokenId), "Token does not exist");
        return tokenIdToName[_tokenId];
    }

    function testFunction() public pure returns (string memory) {
        return "This is a test function";
    }

    // Function to add a new proof
    function addProof(string memory _proof, string memory _topicName) public onlyOwner {
        require(bytes(_proof).length > 0, "Proof cannot be empty");
        require(bytes(_topicName).length > 0, "Topic name cannot be empty");
        proofs.push(Proof(_proof, _topicName));
        emit ProofAdded(proofs.length - 1, _proof, _topicName);
    }

    // Function to get the proof hash by index
    function getProof(uint256 _index) public view returns (bytes32) {
        require(_index < proofs.length, "Index out of bounds");
        Proof memory proof = proofs[_index];
        return keccak256(abi.encodePacked(proof.proof, proof.topicName));
    }
}