// SPDX-License-Identifier: MIT

// Phase 3: Basic Conditional Logic with if
pragma solidity ^0.8.0;

contract AccessControl {
    bool public isOpen;

    function openAccess() public {
        isOpen = true;
    }

    function closeAccess() public {
        isOpen = false;
    }

    function performAction() public view returns (string memory) {
        if (isOpen) {
            return "Action allowed";
        }
        return "Action blocked";
    }
}