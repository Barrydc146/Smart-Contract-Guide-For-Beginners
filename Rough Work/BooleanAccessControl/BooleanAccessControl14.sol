// SPDX-License-Identifier: MIT

// Phase 14: Complete Access Control System
pragma solidity ^0.8.0;

contract AccessControl {
    // System-wide flags
    bool public isOpen;
    bool public isActive;
    bool public isPaused;
    bool public emergencyMode;
    bool public maintenanceMode;

    // User permissions
    mapping(address => bool) public hasAccess;
    mapping(address => bool) public isAdmin;
    mapping(address => bool) public isBanned;
    mapping(address => bool) public isPremium;
    
    // Ownership
    address public owner;

    // Events
    event SystemStatusChanged(bool isOpen, bool isActive, bool isPaused);
    event AccessGranted(address indexed user);
    event AccessRevoked(address indexed user);
    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);
    event EmergencyModeToggled(bool enabled);
    event UserBanned(address indexed user);
    event UserUnbanned(address indexed user);

    constructor() {
        owner = msg.sender;
        isAdmin[msg.sender] = true;
        isOpen = true;
        isActive = true;
    }

    // Modifiers using boolean conditions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Only admin");
        _;
    }

    modifier whenOpen() {
        require(isOpen, "System is closed");
        _;
    }

    modifier whenActive() {
        require(isActive, "System is not active");
        _;
    }

    modifier whenNotPaused() {
        require(!isPaused, "System is paused");
        _;
    }

    modifier whenNotEmergency() {
        require(!emergencyMode, "Emergency mode active");
        _;
    }

    modifier hasPermission() {
        require(hasAccess[msg.sender], "No access permission");
        require(!isBanned[msg.sender], "User is banned");
        _;
    }

    // System control
    function setOpen(bool _status) public onlyAdmin {
        isOpen = _status;
        emit SystemStatusChanged(isOpen, isActive, isPaused);
    }

    function setActive(bool _status) public onlyAdmin {
        isActive = _status;
        emit SystemStatusChanged(isOpen, isActive, isPaused);
    }

    function setPaused(bool _status) public onlyAdmin {
        isPaused = _status;
        emit SystemStatusChanged(isOpen, isActive, isPaused);
    }

    function toggleMaintenance() public onlyAdmin {
        maintenanceMode = !maintenanceMode;
        
        if (maintenanceMode) {
            isOpen = false;
            isPaused = true;
        }
    }

    function enableEmergency() public onlyAdmin {
        emergencyMode = true;
        isOpen = false;
        isPaused = true;
        isActive = false;
        emit EmergencyModeToggled(true);
    }

    function disableEmergency() public onlyOwner {
        emergencyMode = false;
        isPaused = false;
        isActive = true;
        emit EmergencyModeToggled(false);
    }

    // User management
    function grantAccess(address _user) public onlyAdmin {
        require(!isBanned[_user], "Cannot grant access to banned user");
        hasAccess[_user] = true;
        emit AccessGranted(_user);
    }

    function revokeAccess(address _user) public onlyAdmin {
        hasAccess[_user] = false;
        emit AccessRevoked(_user);
    }

    function banUser(address _user) public onlyAdmin {
        require(_user != owner, "Cannot ban owner");
        isBanned[_user] = true;
        hasAccess[_user] = false;
        emit UserBanned(_user);
    }

    function unbanUser(address _user) public onlyAdmin {
        isBanned[_user] = false;
        emit UserUnbanned(_user);
    }

    function setPremium(address _user, bool _status) public onlyAdmin {
        isPremium[_user] = _status;
    }

    // Admin management
    function addAdmin(address _admin) public onlyOwner {
        isAdmin[_admin] = true;
        emit AdminAdded(_admin);
    }

    function removeAdmin(address _admin) public onlyOwner {
        require(_admin != owner, "Cannot remove owner as admin");
        isAdmin[_admin] = false;
        emit AdminRemoved(_admin);
    }

    // User actions with multiple boolean checks
    function performBasicAction() 
        public view whenOpen whenActive whenNotPaused whenNotEmergency hasPermission returns (string memory) 
    {
        return "Basic action executed";
    }

    function performPremiumAction() public view returns (string memory) {
        require(isOpen && isActive && !isPaused, "System unavailable");
        require(hasAccess[msg.sender] && !isBanned[msg.sender], "Access denied");
        require(isPremium[msg.sender], "Premium access required");
        
        return "Premium action executed";
    }

    // Status checks
    function canPerformAction(address _user) public view returns (bool) {
        return isOpen 
            && isActive 
            && !isPaused 
            && !emergencyMode 
            && hasAccess[_user] 
            && !isBanned[_user];
    }

    function getSystemStatus() public view returns (
        bool open,
        bool active,
        bool paused,
        bool emergency,
        bool maintenance
    ) {
        return (isOpen, isActive, isPaused, emergencyMode, maintenanceMode);
    }

    function getUserStatus(address _user) public view returns (
        bool access,
        bool admin,
        bool banned,
        bool premium
    ) {
        return (hasAccess[_user], isAdmin[_user], isBanned[_user], isPremium[_user]);
    }

    // Complex conditional logic
    function getAccessLevel(address _user) public view returns (string memory) {
        if (isBanned[_user]) {
            return "BANNED";
        } else if (isAdmin[_user]) {
            return "ADMIN";
        } else if (isPremium[_user] && hasAccess[_user]) {
            return "PREMIUM USER";
        } else if (hasAccess[_user]) {
            return "STANDARD USER";
        } else {
            return "NO ACCESS";
        }
    }

    function isSystemHealthy() public view returns (bool) {
        return isOpen 
            && isActive 
            && !isPaused 
            && !emergencyMode 
            && !maintenanceMode;
    }
}