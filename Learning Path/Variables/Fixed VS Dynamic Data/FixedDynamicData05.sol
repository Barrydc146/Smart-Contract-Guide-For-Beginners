// SPDX-License-Identifier: MIT

// Phase 5: Storage Layout Awareness
pragma solidity ^0.8.0;

contract FixedVsDynamic {
    // EFFICIENT PACKING: Multiple small fixed types fit in one slot
    uint8 public age;        // 1 byte  \
    uint8 public level;      // 1 byte   |-- All fit in 1 storage slot (32 bytes)
    uint16 public score;     // 2 bytes  |
    uint32 public timestamp; // 4 bytes /
    
    // uint256 takes full slot regardless
    uint256 public largeValue;  // 32 bytes (full slot)
    
    // Dynamic types always take their own space
    string public name;  // Separate, variable storage
    
    function setPackedData(uint8 _age, uint8 _level, uint16 _score, uint32 _time) public {
        // Writing multiple packed values in one transaction can be efficient
        age = _age;
        level = _level;
        score = _score;
        timestamp = _time;
    }

    function setLargeValue(uint256 _value) public {
        largeValue = _value;
    }

    function setName(string memory _name) public {
        name = _name;
    }
}