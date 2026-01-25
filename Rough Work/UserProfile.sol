// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract UserProfile {
    struct Profile {
        string name;
        uint256 age;
        address walletaddress;
        bool exist;
    }
    mapping (address => Profile) public userProfile;

    event ProfileCreated(address indexed user, string name, uint256 age);
    event ProfileUpdated(address indexed user, string field);
    event ProfileDeleted(address indexed user);

    function setProfile(string memory _name, uint256 _age) public {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(_age > 0 && _age < 100, "Invalid Age");
        require(!userProfile[msg.sender].exist, "Profile already exists. Use update functions.");

        userProfile[msg.sender] = Profile(_name, _age, msg.sender, true);
        emit ProfileCreated(msg.sender, _name, _age);
    }

    function profileExists(address _users) public view returns (bool) {
        return userProfile[_users].exist;
    }

    function updateMyName(string memory _newName) public {
        require(userProfile[msg.sender].exist, "Profile does not exist");
        require(bytes(_newName).length > 0, "Name cannot be empty");

        userProfile[msg.sender].name = _newName;
        emit ProfileUpdated(msg.sender, "name");
    }
    function updateMyAge(uint256 _newAge) public {
        require(userProfile[msg.sender].exist, "Profile does not exist");
        require(_newAge > 0 && _newAge < 0, "Invalid Age");

        userProfile[msg.sender].age = _newAge;
        emit ProfileUpdated(msg.sender, "age");
    }
    function updateUsersNameAndAge(address _user, string memory _newName, uint256 _newAge) public {
        require(userProfile[_user].exist, "Profile does not exist");
        require(bytes(_newName).length > 0, "Name cannot be empty");
        require(_newAge > 0 && _newAge < 0, "Invalid Age");

        userProfile[msg.sender].name = _newName;
        userProfile[msg.sender].age = _newAge;
    }
    function deleteProfile() public {
        require(userProfile[msg.sender].exist, "Profile does not exist");

        delete userProfile[msg.sender];
        emit ProfileDeleted(msg.sender);
    }

    function getUsersProfile(address _users) public view returns (string memory, uint256, address) {
        require(userProfile[_users].exist, "Profile does not exist");
        Profile memory profiles = userProfile[_users];
        return (profiles.name, profiles.age, profiles.walletaddress);
    }
    function getMyProfile() public view returns (string memory, uint256, address) {
        require(userProfile[msg.sender].exist, "Profile does not exist");
        Profile memory profiles = userProfile[msg.sender];
        return (profiles.name, profiles.age, profiles.walletaddress);
    }
}