// SPDX-License-Identifier: MIT

// Phase 12: Ternary Operator (Conditional Expression)
pragma solidity ^0.8.0;

contract AccessControl {
    bool public isOpen;
    bool public isPremium;

    function setStatus(bool _open, bool _premium) public {
        isOpen = _open;
        isPremium = _premium;
    }

    // Ternary operator: condition ? valueIfTrue : valueIfFalse
    function getAccessLevel() public view returns (string memory) {
        return isOpen ? "Access Granted" : "Access Denied";
    }

    function getMaxActions() public view returns (uint256) {
        return isPremium ? 100 : 10;  // Premium gets 100, regular gets 10
    }

    // Nested ternary (not recommended, but possible)
    function getDetailedStatus() public view returns (string memory) {
        return isOpen 
            ? (isPremium ? "Premium Access" : "Standard Access")
            : "No Access";
    }

    // Using ternary in calculations
    function calculateFee() public view returns (uint256) {
        uint256 baseFee = 100;
        uint256 discount = isPremium ? 50 : 0;
        return baseFee - discount;
    }
}