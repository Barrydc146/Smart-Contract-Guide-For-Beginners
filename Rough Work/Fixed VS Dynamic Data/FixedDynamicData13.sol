// SPDX-License-Identifier: MIT

// Phase 13: Complete Showcase Contract
pragma solidity ^0.8.0;

contract FixedVsDynamic {
    // ========== DATA STRUCTURES ==========
    
    // Optimized user profile combining fixed and dynamic
    struct UserProfile {
        // Fixed data (frequently accessed, packed efficiently)
        bytes32 usernameHash;   // 32 bytes - slot 1
        uint32 userId;          // 4 bytes  \
        uint32 createdAt;       // 4 bytes   |
        uint16 reputation;      // 2 bytes   |-- slot 2
        uint8 level;            // 1 byte    |
        uint8 badges;           // 1 byte   /
        bool isVerified;        // 1 byte  /
        bool isPremium;         // 1 byte /
    }

    struct UserMetadata {
        // Dynamic data (rarely accessed, variable length)
        string fullUsername;
        string bio;
        string avatarUrl;
        string[] achievements;
    }

    // ========== STORAGE ==========
    mapping(address => UserProfile) public profiles;
    mapping(address => UserMetadata) public metadata;

    // Statistics
    uint256 public totalUsers;
    uint256 public totalGasUsedFixed;
    uint256 public totalGasUsedDynamic;

    // ========== EVENTS ==========
    event ProfileCreated(address indexed user, uint32 userId, bytes32 usernameHash);
    event GasComparison(string operation, uint256 fixedGas, uint256 dynamicGas, uint256 savings);

    // ========== CREATE PROFILE ==========
    function createProfile(
        string memory _username,
        string memory _bio
    ) public {
        require(profiles[msg.sender].userId == 0, "Profile already exists");
        
        uint256 gasBefore = gasleft();
        
        // Store fixed data (optimized)
        bytes32 usernameHash = keccak256(abi.encodePacked(_username));
        uint32 userId = uint32(totalUsers + 1);
        
        profiles[msg.sender] = UserProfile({
            usernameHash: usernameHash,
            userId: userId,
            createdAt: uint32(block.timestamp),
            reputation: 0,
            level: 1,
            badges: 0,
            isVerified: false,
            isPremium: false
        });

        totalGasUsedFixed = gasBefore - gasleft();
        gasBefore = gasleft();

        // Store dynamic data (more expensive)
        metadata[msg.sender] = UserMetadata({
            fullUsername: _username,
            bio: _bio,
            avatarUrl: "",
            achievements: new string[](0)
        });

        totalGasUsedDynamic = gasBefore - gasleft();
        totalUsers++;

        emit ProfileCreated(msg.sender, userId, usernameHash);
        emit GasComparison("Create Profile", totalGasUsedFixed, totalGasUsedDynamic, 
                          totalGasUsedDynamic - totalGasUsedFixed);
    }

    // ========== QUICK OPERATIONS (Fixed Data Only) ==========
    function increaseReputation(uint16 _amount) public {
        require(profiles[msg.sender].userId != 0, "Profile doesn't exist");
        profiles[msg.sender].reputation += _amount;
        // Very cheap: only touches fixed data
    }
    function levelUp() public {
        require(profiles[msg.sender].userId != 0, "Profile doesn't exist");
        profiles[msg.sender].level += 1;
        // Very cheap: only touches fixed data
    }

    function verify() public {
        require(profiles[msg.sender].userId != 0, "Profile doesn't exist");
        profiles[msg.sender].isVerified = true;
        // Very cheap: only touches fixed data
    }

    // ========== EXPENSIVE OPERATIONS (Dynamic Data) ==========
    function updateBio(string memory _newBio) public {
        require(profiles[msg.sender].userId != 0, "Profile doesn't exist");
        metadata[msg.sender].bio = _newBio;
        // More expensive: dynamic string storage
    }

    function addAchievement(string memory _achievement) public {
        require(profiles[msg.sender].userId != 0, "Profile doesn't exist");
        metadata[msg.sender].achievements.push(_achievement);
        // Expensive: dynamic array growth
    }

    // ========== VERIFICATION (Uses Fixed Hash) ==========
    function verifyUsername(string memory _username) public view returns (bool) {
        bytes32 hash = keccak256(abi.encodePacked(_username));
        return profiles[msg.sender].usernameHash == hash;
        // Cheap: fixed-size comparison
    }

    // ========== GETTERS ==========
    function getQuickStats(address _user) public view returns (
        uint32 userId,
        uint16 reputation,
        uint8 level,
        bool isVerified
    ) {
        UserProfile memory profile = profiles[_user];
        return (profile.userId, profile.reputation, profile.level, profile.isVerified);
        // Cheap: only reads fixed data
    }

    function getFullProfile(address _user) public view returns (
        uint32 userId,
        uint16 reputation,
        uint8 level,
        string memory username,
        string memory bio,
        string[] memory achievements
    ) {
        UserProfile memory profile = profiles[_user];
        UserMetadata memory meta = metadata[_user];
        
        return (
            profile.userId,
            profile.reputation,
            profile.level,
            meta.fullUsername,
            meta.bio,
            meta.achievements
        );
        // More expensive: reads dynamic data too
    }

    // ========== ANALYSIS FUNCTIONS ==========
    function getDataTypeSummary() public pure returns (string memory) {
        return 
            "FIXED TYPES: bytes32, uint8-256, bool, address - Predictable size & gas\n"
            "DYNAMIC TYPES: string, arrays - Variable size & gas\n"
            "BEST PRACTICE: Fixed for frequent access, dynamic for rare/variable data";
    }

    function getOptimizationTips() public pure returns (string memory) {
        return
            "1. Pack small fixed types (uint8, uint16, etc.) in structs\n"
            "2. Use bytes32 for strings <= 32 characters\n"
            "3. Store hashes (bytes32) for comparisons, full data separately\n"
            "4. Use uint256 for calculations (EVM native size)\n"
            "5. Separate frequently accessed (fixed) from rare (dynamic) data\n"
            "6. Use fixed-size arrays when length is known\n"
            "7. Measure gas with gasleft() to verify optimizations";
    }

    function getGasComparison() public view returns (
        uint256 fixedDataGas,
        uint256 dynamicDataGas,
        uint256 gasSaved,
        uint256 percentSaved
    ) {
        fixedDataGas = totalGasUsedFixed;
        dynamicDataGas = totalGasUsedDynamic;
        gasSaved = dynamicDataGas - fixedDataGas;
        percentSaved = (gasSaved * 100) / dynamicDataGas;
        
        return (fixedDataGas, dynamicDataGas, gasSaved, percentSaved);
    }
}