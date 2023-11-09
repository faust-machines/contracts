pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {SimpleNFT} from "src/SimpleNFT.sol";

contract SimpleNFTTest is Test {
    SimpleNFT simpleNFT;

    function setUp() public {
        simpleNFT = new SimpleNFT("SimpleNFT", "SNFT");
    }

    function test_MintNFT() public {
        simpleNFT.mintNFT("First NFT");
        assertEq(simpleNFT.balanceOf(address(this)), 1);
    }

    function test_SetName() public {
        simpleNFT.mintNFT("First NFT");
        simpleNFT.setTokenName(1, "Updated NFT");
        assertEq(simpleNFT.getTokenName(1), "Updated NFT");
    }

    function test_GetTokenName() public {
        simpleNFT.mintNFT("First NFT");
        assertEq(simpleNFT.getTokenName(1), "First NFT");
    }

    function test_TestFunction() public {
        assertEq(simpleNFT.testFunction(), "This is a test function");
    }

    function test_TokenDoesNotExist() public {
        try simpleNFT.getTokenName(1) returns (string memory) {
            assertTrue(false, "Should have reverted");
        } catch {
            assertTrue(true, "Expected revert");
        }
    }

    // Tests for the addProof function
    function test_AddProof() public {
        string memory proof = "Proof of Concept";
        string memory topicName = "Topic 1";

        simpleNFT.addProof(proof, topicName);
    }

    // Tests for the getProof function
    function test_GetProof() public {
        string memory proof = "Proof of Concept";
        string memory topicName = "Topic 1";
        simpleNFT.addProof(proof, topicName);
        bytes32 expectedHash = keccak256(abi.encodePacked(proof, topicName));
        bytes32 actualHash = simpleNFT.getProof(0);
        assertEq(actualHash, expectedHash, "The hash of the proof should match the expected hash");
    }

    // Tests for out of bounds in getProof function
    function test_GetProofOutOfBounds() public {
        try simpleNFT.getProof(0) {
            assertTrue(false, "Should have reverted");
        } catch Error(string memory reason) {
            assertEq(reason, "Index out of bounds", "Expected revert with 'Index out of bounds'");
        }
    }

    // Tests for empty proof in addProof function
    function test_AddProofEmptyProof() public {
        string memory proof = "";
        string memory topicName = "Topic 1";
        try simpleNFT.addProof(proof, topicName) {
            assertTrue(false, "Should have reverted");
        } catch Error(string memory reason) {
            assertEq(reason, "Proof cannot be empty", "Expected revert with 'Proof cannot be empty'");
        }
    }

    // Tests for empty topic name in addProof function
    function test_AddProofEmptyTopicName() public {
        string memory proof = "Proof of Concept";
        string memory topicName = "";
        try simpleNFT.addProof(proof, topicName) {
            assertTrue(false, "Should have reverted");
        } catch Error(string memory reason) {
            assertEq(reason, "Topic name cannot be empty", "Expected revert with 'Topic name cannot be empty'");
        }
    }

}