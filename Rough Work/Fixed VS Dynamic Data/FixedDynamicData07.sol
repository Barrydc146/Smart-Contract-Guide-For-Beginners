// SPDX-License-Identifier: MIT

// Phase 7: Dynamic Data - When You Must Use It
pragma solidity ^0.8.0;

contract FixedVsDynamic {
    // When you MUST use dynamic types
    string public userBio;           // Unknown length, potentially long
    string public articleContent;     // Definitely long
    string public jsonMetadata;       // Variable structured data

    // Fixed types can't handle this
    bytes32 public limitedBio;  // Only 32 characters max!

    function setUserBio(string memory _bio) public {
        userBio = _bio;  // Can be 10 chars or 1000 chars
    }

    function setArticleContent(string memory _content) public {
        articleContent = _content;  // Definitely needs dynamic
    }

    function setLimitedBio(bytes32 _bio) public {
        limitedBio = _bio;  // Strict 32 byte limit
    }

    // Demonstrate limitation
    function getBioLength() public view returns (uint256) {
        return bytes(userBio).length;  // Can be any size
    }
}