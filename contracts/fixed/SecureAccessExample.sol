// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SecureAccessExample is Ownable {
    uint256 public privilegedData;

    constructor() Ownable(msg.sender) {}

    function updatePrivilegedData(uint256 _newData) public onlyOwner {
        privilegedData = _newData;
    }
}

// Note: This contract uses OpenZeppelin's Ownable contract to restrict access to the updatePrivilegedData function.
// Only the owner of the contract can call this function, preventing unauthorized access to privileged data.
// This ensures that the contract is secure against unauthorized modifications to privileged data.
