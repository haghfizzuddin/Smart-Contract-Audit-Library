// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AccessBypassExample {
    address public owner;
    uint256 public privilegedData;

    constructor() {
        owner = msg.sender;
    }

    function updatePrivilegedData(uint256 _newData) public {
        privilegedData = _newData;
    }
}
// Note: This contract is vulnerable to access bypass issues.
// The updatePrivilegedData function can be called by anyone, allowing unauthorized access to privileged data.
// It should be restricted to the owner of the contract to prevent unauthorized modifications.
