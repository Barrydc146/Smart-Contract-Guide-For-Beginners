// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FixedVsDynamic {
    // ========== OPTIMIZATION RULE 1: Pack Small Fixed Types ==========
    // ✅ GOOD: Packed into 1 slot
    struct GoodPacking {
        uint32 id;        // 4 bytes  \
        uint16 value1;    // 2 bytes   |
        uint16 value2;    // 2 bytes   |-- 32 bytes total (1 slot)
        uint8 status;     // 1 byte    |
        bool flag;        // 1 byte   /
    }

    // ❌ BAD: Each takes full slot
    struct BadPacking {
        uint256 id;       // 32 bytes (slot 1)
        uint256 value1;   // 32 bytes (slot 2)
        uint256 value2;   // 32 bytes (slot 3)
        uint256 status;   // 32 bytes (slot 4)
        bool flag;        // 32 bytes (slot 5) - wasteful!
    }

    // ========== OPTIMIZATION RULE 2: Short Strings as bytes32 ==========
    // ✅ GOOD: Fixed 32 bytes for short data
    bytes32 public code;  // "ABC123" fits easily, 1 slot
    bytes32 public ticker; // "ETH" or "BTC", 1 slot

    // ❌ BAD: String overhead for short data
    string public codeDynamic;  // Extra storage for length, less efficient

    // ========== OPTIMIZATION RULE 3: Use Hashes for Comparison ==========
    mapping(address => bytes32) public usernameHashes;  // ✅ Fixed size
    mapping(address => string) public usernames;        // ❌ Dynamic size

    function registerUser(string memory _username) public {
        // Store hash for comparisons (cheap)
        usernameHashes[msg.sender] = keccak256(abi.encodePacked(_username));
        // Store full string only if displaying is critical
        // usernames[msg.sender] = _username;  // Skip if not needed
    }

    function verifyUser(string memory _username) public view returns (bool) {
        // Compare hashes (cheap fixed-size comparison)
        return usernameHashes[msg.sender] == keccak256(abi.encodePacked(_username));
    }

    // ========== OPTIMIZATION RULE 4: Default to uint256 ==========
    // ✅ GOOD: Native EVM size, no conversion
    function calculateNative(uint256 a, uint256 b) public pure returns (uint256) {
        return a * b + 100;  // Cheap, no conversion
    }

    // ❌ BAD: Requires conversion overhead
    function calculateWithConversion(uint8 a, uint8 b) public pure returns (uint8) {
        return a * b + 100;  // Converts: uint8 -> uint256 -> calculate -> uint8
    }

    // ========== OPTIMIZATION RULE 5: Separate Hot and Cold Data ==========
    struct HotData {
        uint32 userId;     // Accessed frequently
        uint16 level;      // Accessed frequently
        bool isActive;     // Accessed frequently
    }

    struct ColdData {
        string bio;        // Accessed rarely
        string avatar;     // Accessed rarely
    }

    mapping(address => HotData) public hotStorage;   // ✅ Cheap frequent access
    mapping(address => ColdData) public coldStorage; // ✅ Pay cost only when needed

    // ========== OPTIMIZATION RULE 6: Fixed Arrays When Size Known ==========
    // ✅ GOOD: Size known, use fixed
    uint256[7] public daysOfWeek;  // Always 7 days

    // ❌ BAD: Using dynamic when size is constant
    uint256[] public daysOfWeekDynamic;  // Unnecessary flexibility

    // ========== OPTIMIZATION RULE 7: Avoid Dynamic in Loops ==========
    uint256[] public items;

    // ❌ BAD: Dynamic operations in loop (very expensive)
    function badLoop() public {
        for (uint256 i = 0; i < 100; i++) {
            items.push(i);  // Each push costs gas + storage expansion
        }
    }

    // ✅ BETTER: Pre-calculate and batch
    function betterApproach(uint256[] memory _items) public {
        items = _items;  // Single assignment, calculated off-chain
    }

    // ========== DECISION TREE ==========
    function getRecommendation() public pure returns (string memory) {
        return "1. Data <= 32 bytes and immutable? Use bytes32"
               "2. Small numbers in struct? Use uint8/uint16 and pack"
               "3. Standalone calculations? Use uint256"
               "4. Need comparison only? Store hash (bytes32)"
               "5. Unknown or large length? Use string/dynamic array"
               "6. Frequently accessed? Use fixed types"
               "7. Rarely accessed? Dynamic acceptable";
    }
}