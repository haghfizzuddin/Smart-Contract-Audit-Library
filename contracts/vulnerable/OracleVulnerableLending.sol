// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OracleVulnerableLending {
    IERC20 public collateralToken;
    IERC20 public loanToken;
    address public oracle;

    constructor(address _collateral, address _loanToken, address _oracle) {
        collateralToken = IERC20(_collateral);
        loanToken = IERC20(_loanToken);
        oracle = _oracle;
    }

    function getPrice() public view returns (uint256) {
        // ❌ vulnerable: external untrusted oracle (can be manipulated during flashloan)
        return IERC20(oracle).balanceOf(address(this));
    }

    function borrow(uint256 amount) external {
        uint256 price = getPrice();
        uint256 requiredCollateral = amount * price;

        require(
            collateralToken.transferFrom(msg.sender, address(this), requiredCollateral), "Collateral transfer failed"
        );

        loanToken.transfer(msg.sender, amount);
    }
}
// This contract is vulnerable to oracle manipulation attacks.
// An attacker can manipulate the oracle price during a flash loan to borrow more tokens than they should
// This can lead to draining the contract of its funds, as the collateral required is based on  the manipulated price.
// Users should avoid using contracts that rely on untrusted external oracles for critical operations like lending
// and borrowing, as they can be exploited by malicious actors.
