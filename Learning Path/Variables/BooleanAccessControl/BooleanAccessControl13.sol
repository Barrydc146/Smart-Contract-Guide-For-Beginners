// SPDX-License-Identifier: MIT

// Phase 13: Boolean Short-Circuit Evaluation
pragma solidity ^0.8.0;

contract AccessControl {
    bool public isOpen;
    bool public isActive;
    mapping(address => bool) public hasAccess;
    mapping(address => bool) public isAdmin;
    
    uint256 public checkCounter;

    function setStatus(bool _open, bool _active) public {
        isOpen = _open;
        isActive = _active;
    }

    // This function increments counter
    function expensiveCheck() public returns (bool) {
        checkCounter += 1;  // Side effect to track calls
        return hasAccess[msg.sender];
    }

    // AND short-circuit: if first is false, second never evaluated
    function shortCircuitAND() public returns (string memory) {
        // If isOpen is false, expensiveCheck() is NEVER called
        if (isOpen && expensiveCheck()) {
            return "Both conditions checked";
        }
        return "Short-circuited or failed";
    }

    // OR short-circuit: if first is true, second never evaluated
    function shortCircuitOR() public returns (string memory) {
        // If isAdmin[msg.sender] is true, expensiveCheck() is NEVER called
        if (isAdmin[msg.sender] || expensiveCheck()) {
            return "Access granted";
        }
        return "Access denied";
    }

    // Practical use: safe access pattern
    function safeAccess() public view returns (bool) {
        // Check cheaper condition first
        // If isOpen is false, no need to check mapping
        return isOpen && hasAccess[msg.sender];
    }
}