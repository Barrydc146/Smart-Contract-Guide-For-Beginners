// SPDX-License-Identifier: MIT

//Phase 1: Understanding Fixed-Size uint Types
//Start with the basic building blocks - fixed-size unsigned integers:
pragma solidity ^0.8.0;

contract FixedVsDynamic {
    // Fixed-size unsigned integers (exact size known at compile time)
    uint8 public smallNumber;    // 1 byte  (0 to 255)
    uint16 public mediumNumber;  // 2 bytes (0 to 65,535)
    uint32 public largeNumber;   // 4 bytes (0 to 4,294,967,295)
    uint64 public veryLargeNumber; // 8 bytes
    uint128 public hugeNumber;   // 16 bytes
    uint256 public maxNumber;    // 32 bytes (default)

    function setSmallNumber(uint8 _value) public {
        smallNumber = _value;
    }

    function setMaxNumber(uint256 _value) public {
        maxNumber = _value;
    }
}