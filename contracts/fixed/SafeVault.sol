// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SafeVault {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance");

        balances[msg.sender] = 0;

        (bool sent,) = msg.sender.call{value: amount}("");
        require(sent, "Transfer failed");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
// Note: This contract is designed to be secure against reentrancy attacks.
// It sets the user's balance to zero before transferring funds, preventing reentrancy exploits.
// It is a safer alternative to the vulnerable ReentrancyVault contract.
