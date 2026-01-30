// SPDX-License-Identifier: MIT

// Phase 9: Admin Role with Boolean Flag
pragma solidity ^0.8.0;

contract AccessControl {
    bool public isOpen;
    mapping(address => bool) public hasAccess;
    mapping(address => bool) public isAdmin;
    
    address public owner;

    constructor() {
        owner = msg.sender;  // Contract deployer is owner
        isAdmin[msg.sender] = true;  // Owner is also admin
    }

    // Only admins can call this
    function setOpen(bool _status) public {
        require(isAdmin[msg.sender], "Only admins can change system status");
        isOpen = _status;
    }

    function grantAccess(address _user) public {
        require(isAdmin[msg.sender], "Only admins can grant access");
        hasAccess[_user] = true;
    }

    function revokeAccess(address _user) public {
        require(isAdmin[msg.sender], "Only admins can revoke access");
        hasAccess[_user] = false;
    }

    // Admin management
    function addAdmin(address _admin) public {
        require(msg.sender == owner, "Only owner can add admins");
        isAdmin[_admin] = true;
    }

    function removeAdmin(address _admin) public {
        require(msg.sender == owner, "Only owner can remove admins");
        require(_admin != owner, "Cannot remove owner as admin");
        isAdmin[_admin] = false;
    }

    function restrictedAction() public view returns (string memory) {
        require(isOpen, "System is closed");
        require(hasAccess[msg.sender], "You don't have access");
        return "Action executed";
    }
}