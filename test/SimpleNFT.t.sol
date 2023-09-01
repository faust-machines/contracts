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
}