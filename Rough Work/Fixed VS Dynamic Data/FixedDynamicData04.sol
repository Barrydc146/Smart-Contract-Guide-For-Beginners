// SPDX-License-Identifier: MIT

// Phase 4: Direct Comparison - Gas Costs
pragma solidity ^0.8.0;

contract FixedVsDynamic {
    // Fixed-size storage
    bytes32 public fixedName;
    uint256 public fixedNumber;

    // Dynamic-size storage
    string public dynamicName;
    
    // Store same data in both formats
    function storeFixed(bytes32 _name, uint256 _number) public {
        fixedName = _name;      // Single storage slot write
        fixedNumber = _number;  // Single storage slot write
    }

    function storeDynamic(string memory _name) public {
        dynamicName = _name;    // Multiple operations depending on length
    }

    // Comparison getters
    function getFixed() public view returns (bytes32, uint256) {
        return (fixedName, fixedNumber);  // Read 2 slots
    }

    function getDynamic() public view returns (string memory) {
        return dynamicName;  // Read variable slots
    }
}