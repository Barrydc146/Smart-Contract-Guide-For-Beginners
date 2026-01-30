// SPDX-License-Identifier: MIT

// Phase 2: Fixed-Size bytes32
pragma solidity ^0.8.0;

contract FixedVsDynamic {
    // bytes32: Fixed 32-byte array
    bytes32 public fixedData;
    bytes32 public hashedData;
    bytes32 public name32;

    function setFixedData(bytes32 _data) public {
        fixedData = _data;
    }

    // Store short string as bytes32 (fixed size)
    function setName32(bytes32 _name) public {
        name32 = _name;
    }

    // Hash creates fixed 32-byte output
    function hashData(string memory _input) public {
        hashedData = keccak256(abi.encodePacked(_input));
    }
}