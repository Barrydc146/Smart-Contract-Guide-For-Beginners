// SPDX-License-Identifier: MIT

// Phase 6: Using require for Access Control
pragma solidity ^0.8.0;

contract AccessControl {
    bool public isOpen;
    bool public isActive;

    function setOpen(bool _status) public {
        isOpen = _status;
    }

    function setActive(bool _status) public {
        isActive = _status;
    }

    // Function that requires access to be open
    function restrictedAction() public view returns (string memory) {
        require(isOpen, "Access is closed");
        return "Action executed successfully";
    }

    // Function that requires multiple conditions
    function criticalAction() public view returns (string memory) {
        require(isOpen, "Access is closed");
        require(isActive, "System is not active");
        return "Critical action executed";
    }

    // Function with combined condition
    function combinedAction() public view returns (string memory) {
        require(isOpen && isActive, "Access denied: system closed or inactive");
        return "Combined action executed";
    }
}