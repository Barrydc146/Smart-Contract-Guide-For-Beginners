// SPDX-License-Identifier: MIT

// Phase 8: uint8 vs uint256 - The Surprising Truth
pragma solidity ^0.8.0;

contract FixedVsDynamic {
    uint8 public smallAge;
    uint256 public largeAge;

    // SURPRISING: uint256 is often CHEAPER in calculations!
    function calculateWithUint8(uint8 a, uint8 b) public pure returns (uint8) {
        // EVM converts to uint256, calculates, then converts back to uint8
        return a + b;  // Extra gas for type conversion!
    }

    function calculateWithUint256(uint256 a, uint256 b) public pure returns (uint256) {
        // EVM native size, no conversion needed
        return a + b;  // Cheaper in computation!
    }

    // When uint8 IS beneficial: storage packing
    struct PackedData {
        uint8 age;       // \
        uint8 level;     //  } All fit in one slot = cheaper storage
        uint16 score;    // /
    }

    struct UnpackedData {
        uint256 age;     // Full slot
        uint256 level;   // Full slot
        uint256 score;   // Full slot - 3x more expensive!
    }

    PackedData public packed;
    UnpackedData public unpacked;
}