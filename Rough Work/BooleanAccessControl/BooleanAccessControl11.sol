// SPDX-License-Identifier: MIT

// // Phase 11: Conditional State Changes
pragma solidity ^0.8.0;

contract AccessControl {
    bool public isOpen;
    bool public isActive;
    bool public isPaused;
    bool public emergencyMode;

    mapping(address => bool) public hasAccess;
    mapping(address => bool) public isAdmin;
    
    address public owner;

    constructor() {
        owner = msg.sender;
        isAdmin[msg.sender] = true;
    }

    // Conditional state change based on current state
    function smartToggle() public {
        require(isAdmin[msg.sender], "Only admins");
        
        if (emergencyMode) {
            // If in emergency, first disable it
            emergencyMode = false;
            isOpen = false;
        } else if (!isActive) {
            // If not active, activate first
            isActive = true;
        } else if (isPaused) {
            // If paused, unpause
            isPaused = false;
        } else {
            // Otherwise toggle open/close
            isOpen = !isOpen;
        }
    }

    // Auto-pause if certain conditions met
    function checkAndPause() public {
        if (!isOpen && !isActive) {
            isPaused = true;  // Auto-pause if both are off
        }
    }

    // Cascade effect: changing one bool affects others
    function enableEmergencyMode() public {
        require(isAdmin[msg.sender], "Only admins");
        
        emergencyMode = true;
        isOpen = false;       // Close access
        isPaused = true;      // Pause system
        isActive = false;     // Deactivate
    }

    function disableEmergencyMode() public {
        require(msg.sender == owner, "Only owner can disable emergency");
        
        emergencyMode = false;
        isPaused = false;
        isActive = true;
        // isOpen stays false for manual control
    }
}