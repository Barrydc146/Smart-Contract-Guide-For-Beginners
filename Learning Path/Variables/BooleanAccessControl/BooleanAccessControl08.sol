// SPDX-License-Identifier: MIT

// Phase 8: Multi-User Access Control with Mapping
pragma solidity ^0.8.0;

contract AccessControl {
    bool public isOpen;
    mapping(address => bool) public hasAccess;  // Track who has access

    function setOpen(bool _status) public {
        isOpen = _status;
    }

    // Grant access to a specific user
    function grantAccess(address _user) public {
        hasAccess[_user] = true;
    }

    // Revoke access from a user
    function revokeAccess(address _user) public {
        hasAccess[_user] = false;
    }

    // Check if caller has access
    function checkMyAccess() public view returns (bool) {
        return hasAccess[msg.sender];
    }

    // Function requiring both system open AND user access
    function restrictedAction() public view returns (string memory) {
        require(isOpen, "System is closed");
        require(hasAccess[msg.sender], "You don't have access");
        return "Action executed";
    }
}