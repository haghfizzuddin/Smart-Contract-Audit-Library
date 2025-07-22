// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReentrancyVault {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance");

        (bool sent,) = msg.sender.call{value: amount}("");
        require(sent, "Transfer failed");

        balances[msg.sender] = 0;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
// Note: This contract is vulnerable to reentrancy attacks.
// An attacker can exploit the withdraw function by recursively calling it before the balance is set to zero
