// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract WalletDrainer {
    IERC20 public token;
    address public scammer;

    constructor(address _token) {
        token = IERC20(_token);
        scammer = msg.sender;
    }

    // Fake function - does nothing malicious itself
    function phishingApprove() external {
        // Just a decoy function to simulate scam website UI
        emit ClickedPhishingButton(msg.sender);
    }

    event ClickedPhishingButton(address indexed victim);
}


// This contract is a phishing contract that tricks users into approving a scammer to spend their tokens.
// It allows the scammer to drain tokens from users who interact with it.
// It simulates an airdrop and allows the scammer to drain tokens from users who interact with it.
// Users should be cautious and verify the legitimacy of airdrop contracts before approving token transfers.
// This contract is a demonstration of how malicious actors can exploit trust in airdrop mechanisms.