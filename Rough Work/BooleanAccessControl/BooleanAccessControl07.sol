// SPDX-License-Identifier: MIT

// Phase 7: Toggle Pattern
pragma solidity ^0.8.0;

contract AccessControl {
    bool public isOpen;
    bool public isActive;

    // Toggle: flip the boolean value
    function toggleOpen() public {
        isOpen = !isOpen;  // true becomes false, false becomes true
    }

    function toggleActive() public {
        isActive = !isActive;
    }

    // Alternative toggle with if-else
    function toggleOpenAlternative() public {
        if (isOpen) {
            isOpen = false;
        } else {
            isOpen = true;
        }
    }

    function restrictedAction() public view returns (string memory) {
        require(isOpen && isActive, "Access denied");
        return "Action executed";
    }
}