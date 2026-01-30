// SPDX-License-Identifier: MIT

// Phase 5: Boolean Operators (Logical AND, OR, NOT)
pragma solidity ^0.8.0;

contract AccessControl {
    bool public isOpen;
    bool public isActive;
    bool public isPaused;

    function setOpen(bool _status) public {
        isOpen = _status;
    }

    function setActive(bool _status) public {
        isActive = _status;
    }

    function setPaused(bool _status) public {
        isPaused = _status;
    }

    // Logical AND: Both conditions must be true
    function canAccessAND() public view returns (bool) {
        return isOpen && isActive;  // true only if BOTH are true
    }

    // Logical OR: At least one condition must be true
    function canAccessOR() public view returns (bool) {
        return isOpen || isActive;  // true if EITHER is true
    }

    // Logical NOT: Inverts the boolean
    function isNotPaused() public view returns (bool) {
        return !isPaused;  // true becomes false, false becomes true
    }

    // Complex conditions
    function canPerformAction() public view returns (bool) {
        // Must be open AND active AND NOT paused
        return isOpen && isActive && !isPaused;
    }
}