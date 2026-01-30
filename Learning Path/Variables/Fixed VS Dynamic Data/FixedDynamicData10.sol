// SPDX-License-Identifier: MIT

// Phase 10: Hybrid Approach - Best of Both Worlds
pragma solidity ^0.8.0;

contract FixedVsDynamic {
    // HYBRID: Use fixed for frequently accessed, dynamic for rare/large data
    struct HybridUserProfile {
        // Fixed: frequently accessed, small data
        bytes32 usernameHash;  // Hash of username (fixed 32 bytes)
        uint32 userId;         // ID (4 bytes)
        uint16 reputation;     // Score (2 bytes)
        uint8 level;           // Level (1 byte)
        bool isVerified;       // Status (1 byte)
        
        // For dynamic data, store it separately and reference by ID
        // This keeps the main struct efficient
    }

    struct UserMetadata {
        // Dynamic: rarely accessed, variable length
        string fullUsername;   // Original username (if needed)
        string bio;            // User biography
        string avatarUrl;      // Image URL
    }

    // Main storage: fixed data (cheap to access frequently)
    mapping(address => HybridUserProfile) public profiles;
    
    // Secondary storage: dynamic data (accessed only when needed)
    mapping(address => UserMetadata) public metadata;

    // ========== EFFICIENT PATTERN ==========
    function createProfile(
        string memory _username,
        uint32 _userId,
        string memory _bio
    ) public {
        // Store hash (fixed) in main profile for quick checks
        bytes32 usernameHash = keccak256(abi.encodePacked(_username));
        
        profiles[msg.sender] = HybridUserProfile({
            usernameHash: usernameHash,
            userId: _userId,
            reputation: 0,
            level: 1,
            isVerified: false
        });

        // Store full data separately, accessed only when displaying profile
        metadata[msg.sender] = UserMetadata({
            fullUsername: _username,
            bio: _bio,
            avatarUrl: ""
        });
    }

    // Quick verification: uses only fixed data (cheap)
    function verifyUsername(string memory _username) public view returns (bool) {
        bytes32 hash = keccak256(abi.encodePacked(_username));
        return profiles[msg.sender].usernameHash == hash;
    }

    // Full profile: fetch both when needed
    function getFullProfile(address _user) public view returns (
        uint32 userId,
        uint16 reputation,
        uint8 level,
        bool isVerified,
        string memory username,
        string memory bio
    ) {
        HybridUserProfile memory profile = profiles[_user];
        UserMetadata memory meta = metadata[_user];
        
        return (
            profile.userId,
            profile.reputation,
            profile.level,
            profile.isVerified,
            meta.fullUsername,
            meta.bio
        );
    }

    // Update reputation: only touches fixed data (very cheap)
    function updateReputation(uint16 _newRep) public {
        profiles[msg.sender].reputation = _newRep;
    }

    // Update bio: only touches dynamic data when needed (expensive but rare)
    function updateBio(string memory _newBio) public {
        metadata[msg.sender].bio = _newBio;
    }
}