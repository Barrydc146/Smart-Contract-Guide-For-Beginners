// SPDX-License-Identifier: MIT

// Phase 11: Array Comparison - Fixed vs Dynamic
pragma solidity ^0.8.0;

contract FixedVsDynamic {
    // FIXED-SIZE ARRAY: Size known at compile time
    uint256[5] public fixedArray;  // Always 5 elements, no more, no less
    bytes32[10] public fixedHashes; // Always 10 elements

    // DYNAMIC ARRAY: Size can change at runtime
    uint256[] public dynamicArray;  // Can grow/shrink
    string[] public dynamicStrings; // Can have any number of elements

    // ========== FIXED ARRAY OPERATIONS ==========
    function setFixedArray(uint256[5] memory _values) public {
        fixedArray = _values;  // Must be exactly 5 elements
    }

    function getFixedArrayElement(uint256 _index) public view returns (uint256) {
        require(_index < 5, "Index out of bounds");
        return fixedArray[_index];
    }

    function getFixedArrayLength() public pure returns (uint256) {
        return 5;  // Always returns 5, known at compile time
    }

    // ========== DYNAMIC ARRAY OPERATIONS ==========
    function addToDynamicArray(uint256 _value) public {
        dynamicArray.push(_value);  // Array grows
    }

    function removeFromDynamicArray() public {
        dynamicArray.pop();  // Array shrinks
    }

    function getDynamicArrayElement(uint256 _index) public view returns (uint256) {
        require(_index < dynamicArray.length, "Index out of bounds");
        return dynamicArray[_index];
    }

    function getDynamicArrayLength() public view returns (uint256) {
        return dynamicArray.length;  // Runtime value, can change
    }

    // ========== GAS COMPARISON ==========
    function writeFixedArray() public {
        // Writing to fixed array: predictable gas
        for (uint256 i = 0; i < 5; i++) {
            fixedArray[i] = i;
        }
    }

    function writeDynamicArray() public {
        // Writing to dynamic array: variable gas depending on size
        delete dynamicArray;  // Clear first
        for (uint256 i = 0; i < 5; i++) {
            dynamicArray.push(i);  // Each push has overhead
        }
    }
}