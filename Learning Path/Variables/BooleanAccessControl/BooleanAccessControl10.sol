// SPDX-License-Identifier: MIT

// Phase 10: Comparison Operators with Booleans
pragma solidity ^0.8.0;

contract AccessControl {
    bool public isOpen;
    bool public isActive;
    bool public isPaused;

    function setStatus(bool _open, bool _active, bool _paused) public {
        isOpen = _open;
        isActive = _active;
        isPaused = _paused;
    }

    // Equality comparison
    function areEqual(bool a, bool b) public pure returns (bool) {
        return a == b;  // true if both are same value
    }

    // Inequality comparison
    function areNotEqual(bool a, bool b) public pure returns (bool) {
        return a != b;  // true if different values
    }

    // Check if all flags match expected state
    function isExpectedState(bool _expectedOpen, bool _expectedActive) public view returns (bool) {
        return (isOpen == _expectedOpen) && (isActive == _expectedActive);
    }

    // Using comparison in conditions
    function compareAndAct() public view returns (string memory) {
        if (isOpen == isActive) {
            return "Both flags have same value";
        } else {
            return "Flags have different values";
        }
    }
}