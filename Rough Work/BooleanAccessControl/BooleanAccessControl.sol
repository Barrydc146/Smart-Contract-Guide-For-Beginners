// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract AccessControl {
    bool public isOpen;
    bool public isActive = true;
    bool public isPaused = false;

    function openAccess() public {
        isOpen = true;
    }
    function closeAccess() public {
        isOpen = false;
    }
    function performAction() public view returns (string memory) {
        if (isOpen) {
            return "Action Allowed.";
        }
        return "Action Blocked.";
    }
}