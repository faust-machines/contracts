// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Verifier.sol";

contract VerifierTest is Test {
    Verifier public verifier;

    function setUp() public {
        verifier = new Verifier();
    }

    function testVerifyingKey() public {
        Verifier.VerifyingKey memory vk = verifier.getVerifyingKey();
        
        // Test a few known values from the verifyingKey function
        assertEq(vk.alpha.X, 0x22402ce11c3aa692037460cedf42b102270a926950ba47aea59e572a0f296d7e);
        assertEq(vk.alpha.Y, 0x2d146e4e8d4135c22ab2c9f7a020de5431b93ed4e178ee8cf281f04a6bd661c5);
        assertEq(vk.beta.X[0], 0x071118d44db25208a24f07e6b7595cd857f904de0ee722a48030540de32a0514);
        assertEq(vk.gamma_abc.length, 8);
    }

    function testVerify() public {
        // This is an internal function, so we'll test it through verifyTx
        // The test cases for verifyTx will indirectly test this function
    }

   function testVerifyTxWithValidProof() public {
        uint[2] memory a = [
            0x2a3b1f45e791f4418f4888dea42bfc945277f7059465ead27a1c9fce25da42ef,
            0x15de6c82b9fdeb230c4fb97b81e5be1321021c2c26aeb5e5dcc1e9bc1f90c59f
        ];
        uint[2][2] memory b = [
            [
                0x119652657f969ee20a7c340c6a54c48b71adebe2cafbeb9384d3ec9e39f1f2a0,
                0x27d058b3cf9d7fa099059bbf12908e839d32dca6f3365a249f4c89c664cef66d
            ],
            [
                0x16d04d9e8dda04143c964d21fb116a5286603e30445dee5b99a6354e080a1eb2,
                0x27270a4c949293e05611ba4c7e994f3fbc7e38c0fc31155d245526122ddf6aca
            ]
        ];
        uint[2] memory c = [
            0x0e3f0b79ecf8794349499eaaee9d79807efea021a016b995d46dc6e83edc829e,
            0x1aef3b0ab09c0b4c5f6fb1307daed67b7872c348a248f8de8f368c038ec2bdd2
        ];
        uint[7] memory input = [
            0x00000000000000000000000000000000c25d1e89b639df0a5bdd6311a4b27bb7,
            0x000000000000000000000000000000005fb41647b54ae8b6d8ce3f23079993e9,
            0x0bc7710ec53539f8cb7d4f73a504261f55465a69e9675463a37bf17b7a05f710,
            0x1dfb1f820fb43b7ed73f8e4ed1be5ebee71c2f2278f334013e76176fbdeedfa0,
            0x00000000000000000000000000000000000000000000000000000000f39fd6e5,
            0x000000000000000000000000000000001aad88f6f4ce6ab8827279cfffb92266,
            0x0000000000000000000000000000000000000000000000000000000000000000
        ];

        Verifier.Proof memory proof = Verifier.Proof({
            a: Pairing.G1Point(a[0], a[1]),
            b: Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]),
            c: Pairing.G1Point(c[0], c[1])
        });

        bool result = verifier.verifyTx(proof, input);
        assertTrue(result, "Verification should succeed with valid proof and input");
    }

    function testVerifyTxWithInvalidProof() public {
        // TODO: Replace with an invalid proof and input
        Verifier.Proof memory proof = Verifier.Proof({
            a: Pairing.G1Point(0, 0),
            b: Pairing.G2Point([uint256(0), uint256(0)], [uint256(0), uint256(0)]),
            c: Pairing.G1Point(0, 0)
        });
        uint[7] memory input = [uint(0), 0, 0, 0, 0, 0, 0];

        bool result = verifier.verifyTx(proof, input);
        assertFalse(result, "Verification should fail with invalid proof and input");
    }

    // Pairing library tests
    function testPairingAddition() public {
        Pairing.G1Point memory p1 = Pairing.P1();
        Pairing.G1Point memory p2 = Pairing.negate(Pairing.P1());
        Pairing.G1Point memory result = Pairing.addition(p1, p2);
        // The result of P + (-P) should be the point at infinity, represented by (0, 0)
        assertEq(result.X, 0);
        assertEq(result.Y, 0);
    }

    function testPairingScalarMul() public {
        Pairing.G1Point memory p = Pairing.G1Point(1, 2);
        uint s = 3;
        Pairing.G1Point memory result = Pairing.scalar_mul(p, s);
        // The actual result depends on the elliptic curve operations
        // For now, we'll just check that the result is not zero
        assertTrue(result.X != 0 || result.Y != 0, "Scalar multiplication result should not be zero");
    }

    function testPairingPairingCheck() public {
        Pairing.G1Point[] memory p1 = new Pairing.G1Point[](2);
        Pairing.G2Point[] memory p2 = new Pairing.G2Point[](2);
        
        p1[0] = Pairing.P1();
        p1[1] = Pairing.negate(Pairing.P1());
        p2[0] = Pairing.P2();
        p2[1] = Pairing.P2();

        bool result = Pairing.pairing(p1, p2);
        assertTrue(result, "Pairing check should return true for this specific input");
    }
}
