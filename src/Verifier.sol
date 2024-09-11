// This file is MIT Licensed.
//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
pragma solidity ^0.8.20;

library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() pure internal returns (G1Point memory) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() pure internal returns (G2Point memory) {
        return G2Point(
            [10857046999023057135944570762232829481370756359578518086990519993285655852781,
             11559732032986387107991004021392285783925812861821192530917403151452391805634],
            [8495653923123431417604973247489272438418190587263600148770280649306958101930,
             4082367875863433681332203403145435568316851327593401208105741076214120093531]
        );
    }
    /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point memory p) pure internal returns (G1Point memory) {
        // The prime q in the base field F_q for G1
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return r the sum of two points of G1
    function addition(G1Point memory p1, G1Point memory p2) internal view returns (G1Point memory r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 6, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
    }


    /// @return r the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point memory p, uint s) internal view returns (G1Point memory r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success);
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] memory p1, G2Point[] memory p2) internal view returns (bool) {
        require(p1.length == p2.length);
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[1];
            input[i * 6 + 3] = p2[i].X[0];
            input[i * 6 + 4] = p2[i].Y[1];
            input[i * 6 + 5] = p2[i].Y[0];
        }
        uint[1] memory out;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2,
            G1Point memory d1, G2Point memory d2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}

contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G1Point alpha;
        Pairing.G2Point beta;
        Pairing.G2Point gamma;
        Pairing.G2Point delta;
        Pairing.G1Point[] gamma_abc;
    }
    struct Proof {
        Pairing.G1Point a;
        Pairing.G2Point b;
        Pairing.G1Point c;
    }
    function verifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.alpha = Pairing.G1Point(uint256(0x22402ce11c3aa692037460cedf42b102270a926950ba47aea59e572a0f296d7e), uint256(0x2d146e4e8d4135c22ab2c9f7a020de5431b93ed4e178ee8cf281f04a6bd661c5));
        vk.beta = Pairing.G2Point([uint256(0x071118d44db25208a24f07e6b7595cd857f904de0ee722a48030540de32a0514), uint256(0x0627f1852bab0656b970b612f6b3e9f05b01a9f7865505ce60714fc603e6e9a5)], [uint256(0x00812d862471eb789366b9adbf52e3ab3f2011f1c9efe60c7a8d617c742b5a36), uint256(0x0e166a30d2be1619ee8157bcd932767a187732bfecc35bd57946fd9a594789f8)]);
        vk.gamma = Pairing.G2Point([uint256(0x03737c4e209548f983d6fc36383b15e4c0e81dc2c661eca5dea75302033f2b5d), uint256(0x18c5596eafa08c34fb842cba5ec8004e8b82ed4d2b4f4a73458d3e332c49ca63)], [uint256(0x1f40dfcad4581aad8ed15abe48678436321563db6146f10fb347d86d34ca85ef), uint256(0x18f44643d6dfb55fabf305adc50417696b717814279c6e550fd8c7fbaceb431d)]);
        vk.delta = Pairing.G2Point([uint256(0x27c118b70e0bbb20abaca5f1b4a2a9c74d2f5f19e1c82c2cb6ba9fb28c566d46), uint256(0x0299139d03dde18cf4c7afec1b3b016e79a916bb549897217724c652494f8154)], [uint256(0x29e37ddc7df060da94acc0faf1c9f5a6259050a3cc0c802ad3e1a88808b63da7), uint256(0x1698f33d2bb84b1666de7d77d168444a5ce61cf9d4ff097df08fec011af36a01)]);
        vk.gamma_abc = new Pairing.G1Point[](8);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x2569c02ec25ab89d46a94af9db5ac49bfb9e3d64e1f39236b85e26f96afd95bd), uint256(0x2102db0c0679aaeaff71f4441663b12f7d3640630884360b4bda36e4e48037e0));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x0117bc713f61f4d98dacdc4c413f66b7cc1f09ed2606a5ced757c9b158a321fe), uint256(0x0ab680e41e0f3be455afb9923b9465af2f45a94808d4857f0888f6b2e529a34d));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x0919f8895da493307daadb88a2fdf5601e55e11a0cd9969af2ef78bcdb3b45bf), uint256(0x0ca22d9fa53455286e7eb0f22c6700700839af196281509a43f89203bdfd0120));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x00cdbfc1dbdae7ba15d80f13388eb2cd48f94d4225bd9a3ca3b91f9fd42078d7), uint256(0x1566704ac9a15e654133646242a8b8c888c0741d797acd3fe1ed5e61b42a892a));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x2030de9ae36857de3606ca41f8c79b726d0ae645d14b60108ecd4990d88fa47a), uint256(0x289c13d52447677ad8b9ee22d1442cb9743b36fe0bafeccb1467ed22be5357bc));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x0c0dd305660f36f8e824c944aa1da2f84074e79a4ea4373324d0460977e16e21), uint256(0x26f6d3969aca1f9f5da6fc4eedd505e2b26e7b6946df030e18cd7d3ea01261a3));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x0b3220f0c5f83c6629c2ed190cba52d3610be9fa06aadc23510d8709cf82ce1c), uint256(0x2046b3e5bd62dca2d0d633a2f814172b3fd78c9f9ff6588504b9240d49206e27));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x2650f7d3ae6ec10affb3cbe6aa1f11973500b01e61c009b128c26fe7f8e47625), uint256(0x2f88c79561930792189ac80ae619a94d31976edaadb7ebf250f7930e1961f1a5));
    }
    function verify(uint[] memory input, Proof memory proof) internal view returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.gamma_abc.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++) {
            require(input[i] < snark_scalar_field);
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.gamma_abc[i + 1], input[i]));
        }
        vk_x = Pairing.addition(vk_x, vk.gamma_abc[0]);
        if(!Pairing.pairingProd4(
             proof.a, proof.b,
             Pairing.negate(vk_x), vk.gamma,
             Pairing.negate(proof.c), vk.delta,
             Pairing.negate(vk.alpha), vk.beta)) return 1;
        return 0;
    }
    function verifyTx(
            Proof memory proof, uint[7] memory input
        ) public view returns (bool r) {
        uint[] memory inputValues = new uint[](7);
        
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            return true;
        } else {
            return false;
        }
    }
    // Add this function at the end of the Verifier contract
    function getVerifyingKey() public pure returns (VerifyingKey memory) {
        return verifyingKey();
    }
}
