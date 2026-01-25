// SPDX-License-Identifier: MIT

// Phase 3: Understanding Dynamic string Type
pragma solidity ^0.8.0;

contract FixedVsDynamic {
    // string: Dynamic-size data (can grow/shrink)
    string public dynamicName;
    string public description;
    string public longText;

    function setDynamicName(string memory _name) public {
        dynamicName = _name;
    }

    function setDescription(string memory _desc) public {
        description = _desc;
    }

    function setLongText(string memory _text) public {
        longText = _text;
    }

    // Get string length
    function getNameLength() public view returns (uint256) {
        return bytes(dynamicName).length;
    }
}