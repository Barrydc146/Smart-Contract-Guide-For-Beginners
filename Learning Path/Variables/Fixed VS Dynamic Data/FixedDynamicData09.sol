// SPDX-License-Identifier: MIT

// Phase 9: Complete Comparison Contract with Metrics
pragma solidity ^0.8.0;

contract FixedVsDynamic {
    // ========== FIXED SIZE STORAGE ==========
    // EFFICIENT: Packed into fewer slots
    struct FixedUserData {
        bytes32 username;    // 32 bytes - slot 1
        uint32 userId;       // 4 bytes  \
        uint16 age;          // 2 bytes   |-- slot 2 (packed)
        uint8 level;         // 1 byte   /
        bool isActive;       // 1 byte  /
    }

    // ========== DYNAMIC SIZE STORAGE ==========
    // EXPENSIVE: Each field uses variable space
    struct DynamicUserData {
        string username;     // Variable length
        uint256 userId;      // 32 bytes
        uint256 age;         // 32 bytes
        uint256 level;       // 32 bytes
        bool isActive;       // 1 byte (but takes full slot)
    }

    FixedUserData public fixedUser;
    DynamicUserData public dynamicUser;

    // Gas tracking
    uint256 public lastFixedGasUsed;
    uint256 public lastDynamicGasUsed;

    // ========== STORE FIXED DATA ==========
    function storeFixedData(
        bytes32 _username,
        uint32 _userId,
        uint16 _age,
        uint8 _level,
        bool _isActive
    ) public {
        uint256 gasBefore = gasleft();
        
        fixedUser = FixedUserData({
            username: _username,
            userId: _userId,
            age: _age,
            level: _level,
            isActive: _isActive
        });
        
        lastFixedGasUsed = gasBefore - gasleft();
    }

    // ========== STORE DYNAMIC DATA ==========
    function storeDynamicData(
        string memory _username,
        uint256 _userId,
        uint256 _age,
        uint256 _level,
        bool _isActive
    ) public {
        uint256 gasBefore = gasleft();
        
        dynamicUser = DynamicUserData({
            username: _username,
            userId: _userId,
            age: _age,
            level: _level,
            isActive: _isActive
        });
        
        lastDynamicGasUsed = gasBefore - gasleft();
    }

    // ========== COMPARISON FUNCTIONS ==========
    function getGasDifference() public view returns (uint256) {
        return lastDynamicGasUsed - lastFixedGasUsed;
    }

    function getGasSavingsPercentage() public view returns (uint256) {
        if (lastDynamicGasUsed == 0) return 0;
        return ((lastDynamicGasUsed - lastFixedGasUsed) * 100) / lastDynamicGasUsed;
    }

    // ========== READ COMPARISONS ==========
    function readFixed() public view returns (
        bytes32 username,
        uint32 userId,
        uint16 age,
        uint8 level,
        bool isActive
    ) {
        return (
            fixedUser.username,
            fixedUser.userId,
            fixedUser.age,
            fixedUser.level,
            fixedUser.isActive
        );
    }

    function readDynamic() public view returns (
        string memory username,
        uint256 userId,
        uint256 age,
        uint256 level,
        bool isActive
    ) {
        return (
            dynamicUser.username,
            dynamicUser.userId,
            dynamicUser.age,
            dynamicUser.level,
            dynamicUser.isActive
        );
    }
}