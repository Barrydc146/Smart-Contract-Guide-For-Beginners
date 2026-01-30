// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract BalanceTracker {
    mapping (address => uint256) public balance;
    uint256 public totalSupply;
    uint256 public totalUsers;

    uint256 public constant MAX_BALANCE = 1000000;
    uint256 public constant MAX_TOTAL_SUPPLY = 10000000;
    uint256 public constant MIN_TRANSACTION = 1;
    uint256 public constant MAX_TRANSACTION = 10000;
    
    // event
    event BalanceIncreased(address indexed user, uint256 amount, uint256 newBalance );
    event BalanceDecreased(address indexed user, uint256 amount, uint256 newBalance );
    event Transfer(address indexed from, uint256 to, uint256 amount );

    function increaseBalance(uint256 _amount) public {
        require(_amount >= MIN_TRANSACTION, "Below minimum transaction");
        require(_amount <= MAX_TRANSACTION, "Above maximum transaction");
        require(balance[msg.sender] + _amount <= MAX_BALANCE, "Balance limit exceeded");
        require(totalSupply + _amount <= MAX_TOTAL_SUPPLY, "Supply limit exceeded");

        if (balance[msg.sender] == 0) {
            totalUsers += 1;
        }
        
        balance[msg.sender] += _amount;
        totalSupply += _amount;

        emit BalanceIncreased(msg.sender, _amount, balance[msg.sender]);
    }
    function decreaseBalance(uint256 _amount) public {
        require(_amount >= MIN_TRANSACTION, "Below minimum transaction");
        require(_amount <= MAX_TRANSACTION, "Above maximum transaction");
        require(balance[msg.sender] >= _amount, "Insufficient Balance");

        if (balance[msg.sender] == 0) {
            totalUsers -= 1;
        }
        
        balance[msg.sender] -= _amount;
        totalSupply -= _amount;

        emit BalanceDecreased(msg.sender, _amount, balance[msg.sender]);
    }
    function increaseUsersBalance(address _user, uint256 _amount) public {
        require(_amount >= MIN_TRANSACTION, "Below minimum transaction");
        require(_amount <= MAX_TRANSACTION, "Above maximum transaction");
        require(balance[_user] + _amount <= MAX_BALANCE, "Balance limit exceeded");
        require(totalSupply + _amount <= MAX_TOTAL_SUPPLY, "Supply limit exceeded");

        if (balance[_user] == 0) {
            totalUsers += 1;
        }
        
        balance[_user] += _amount;
        totalSupply += _amount;

        emit BalanceIncreased(_user, _amount, balance[_user]);
    }
    function decreaseUsersBalance(address _user, uint256 _amount) public {
        require(_amount >= MIN_TRANSACTION, "Below minimum transaction");
        require(_amount <= MAX_TRANSACTION, "Above maximum transaction");
        require(balance[_user] >= _amount, "Insufficient Balance");

        if (balance[_user] == 0) {
            totalUsers -= 1;
        }
        
        balance[_user] -= _amount;
        totalSupply -= _amount;

        emit BalanceDecreased(_user, _amount, balance[_user]);
    }

    function increaseByPercentage(uint256 _percentage) public {
        require(_percentage > 0 && _percentage < 100, "Invalid Percentage");
        require(balance[msg.sender] > 0, "Balance is zero");

        uint256 increaseAmount = (balance[msg.sender] * _percentage) / 100; 

        require(increaseAmount >= MIN_TRANSACTION, "Below minimum transaction");
        require(balance[msg.sender] + increaseAmount <= MAX_BALANCE, "Balance limit exceeded");
        require(totalSupply + increaseAmount <= MAX_TOTAL_SUPPLY, "Supply limit exceeded");

        balance[msg.sender] += increaseAmount;
        totalSupply += increaseAmount;
    }
    function decreaseByPercentage(uint256 _percentage) public {
        require(_percentage > 0 && _percentage < 100, "Invalid Percentage");
        require(balance[msg.sender] > 0, "Balance is zero");

        uint256 decreaseAmount = (balance[msg.sender] * _percentage) / 100;

        require(decreaseAmount >= MIN_TRANSACTION, "Below minimum transaction");
        
        balance[msg.sender] -= decreaseAmount;
        totalSupply -= decreaseAmount;
    }

    // transfer from one user to another 
    function transfer(address _to, uint256 _amount) public {
        require(_to != address(0), "Cannot send to zero address.");
        require(_to != msg.sender, "Cannot Send to yourself.");
        require(_amount >= MIN_TRANSACTION, "Below minimum transaction");
        require(_amount <= MAX_TRANSACTION, "Above maximum transaction");
        require(balance[msg.sender] >= _amount, "Insufficient Balance");
        require(balance[_to] + _amount <= MAX_BALANCE, "Would exceed max balance");

        balance[msg.sender] -= _amount;

        // Track if recipient is new user
        if (balance[_to] == 0) {
            totalUsers += 1;
        }
        
        balance[_to] += _amount;
        
        // Track if sender now has zero balance
        if (balance[msg.sender] == 0) {
            totalUsers -= 1;
        }
        
        emit Transfer(msg.sender, balance[msg.sender], _amount);
    }

    // using getter
    function getMyBalance() public view returns (uint256) {
        return balance[msg.sender];
    }
    function getUsersBalance(address _user) public view returns (uint256) {
        return balance[_user];
    }
    function canAfford(uint256 _amount) public view returns (bool) {
        return balance[msg.sender] >= _amount;
    }
    function getRemainingBalance() public view returns (uint256) {
        return MAX_BALANCE - balance[msg.sender];
    }
    function getRemainingSupply() public view returns (uint256) {
        return MAX_TOTAL_SUPPLY - totalSupply;
    }
}