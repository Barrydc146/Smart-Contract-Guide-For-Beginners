// SPDX-License-Identifier: MIT

// Phase 4: if-else Statements
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
        } else {
            return "Action blocked";
        }
    }
    
    function checkStatus() public view returns (string memory) {
        if (isOpen == true) {  // Explicit comparison (redundant but shows concept)
            return "System is OPEN";
        } else {
            return "System is CLOSED";
        }
    }
}