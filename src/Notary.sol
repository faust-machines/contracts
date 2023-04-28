contract Notary {
    address private deployer;
    mapping(bytes32 => bytes32[]) private proofs;

    constructor() {
        deployer = msg.sender;
    }

    function addProof(bytes32 key, bytes32[] memory values) public {
        require(msg.sender == deployer, "Only the deployer can call this function");
        for (uint i = 0; i < values.length; i++) {
            proofs[key].push(values[i]);
        }
    }

    function addProofs(bytes32[] memory keys, bytes32[][] memory values) public {
        require(msg.sender == deployer, "Only the deployer can call this function");
        require(keys.length == values.length, "Number of keys and values arrays must match");
        for (uint i = 0; i < keys.length; i++) {
            for (uint j = 0; j < values[i].length; j++) {
                proofs[keys[i]].push(values[i][j]);
            }
        }
    }

    function getProofs(bytes32 key) public view returns (bytes32[] memory) {
        return proofs[key];
    }
}