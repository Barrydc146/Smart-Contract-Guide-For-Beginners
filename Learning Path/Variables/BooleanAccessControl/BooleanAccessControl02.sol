// SPDX-License-Identifier: MIT

// Phase 2: Boolean Literals and Assignment
pragma solidity ^0.8.0;

contract AccessControl {
    bool public isOpen;
    bool public isActive = true;   // Initialized to true
    bool public isPaused = false;  // Explicitly set to false (same as default)

    function openAccess() public {
        isOpen = true;  // Set to true
    }

    function closeAccess() public {
        isOpen = false;  // Set to false
    }
}