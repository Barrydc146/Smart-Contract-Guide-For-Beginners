// SPDX-License-Identifier: MIT

// Phase 6: bytes32 vs string for Short Data
pragma solidity ^0.8.0;

contract FixedVsDynamic {
    // Storing "Hello" - which is cheaper?
    bytes32 public nameAsBytes32;  // Fixed: always 32 bytes
    string public nameAsString;    // Dynamic: stores length + data

    function storeAsBytes32(bytes32 _name) public {
        nameAsBytes32 = _name;  // ~22,000 gas for first write
    }

    function storeAsString(string memory _name) public {
        nameAsString = _name;   // ~45,000+ gas for first write (more overhead)
    }

    // Convert string to bytes32 (for short strings)
    function stringToBytes32(string memory _source) public pure returns (bytes32 result) {
        bytes memory temp = bytes(_source);
        require(temp.length <= 32, "String too long for bytes32");
        
        assembly {
            result := mload(add(temp, 32))
        }
    }

    // Convert bytes32 to string
    function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
        uint8 i = 0;
        while(i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (uint8 j = 0; j < i; j++) {
            bytesArray[j] = _bytes32[j];
        }
        return string(bytesArray);
    }
}