// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Counter {
    uint256 public count;

    event Incremented(uint256 newCount);
    event Decremented(uint256 newCount);
    event Reset();

    function increment() public {
        count += 1;
        emit Incremented(count);
    }
    function decrement() public {
        require(count > 0, "Count cannot be Negative");
        count -=1;
        emit Decremented(count);

    }
    function reset() public {
        count = 0;
        emit Reset();
    }

    function getCount() public view returns(uint256) {
        return count;
    }
}