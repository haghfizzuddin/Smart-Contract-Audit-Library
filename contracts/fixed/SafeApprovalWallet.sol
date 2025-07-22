// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SafeApprovalWallet {
    IERC20 public token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function claimReward() external {
        // Safe function, no malicious approval logic
        // Example: emits a harmless event
        emit RewardClaimed(msg.sender);
    }

    event RewardClaimed(address indexed user);
}
// Note: This contract is designed to be secure against malicious approval logic.
// It does not allow unauthorized token transfers and does not trick users into approving malicious contracts.
// This contract serves as a safe alternative to potentially harmful airdrop contracts.