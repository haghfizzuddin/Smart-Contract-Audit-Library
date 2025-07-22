# 📝 Flashloan Oracle Manipulation Audit Summary

## ❌ Issue: External Oracle Exploitation
The contract relies on an **untrusted external oracle reference** via the `getPrice()` function:
```solidity
function getPrice() public view returns (uint256) {
    return IERC20(oracle).balanceOf(address(this));
}

 Root Cause
    ❗ Misuse of internal balances as price feed — balanceOf() is an unreliable oracle mechanism.
    ❗ No access control or delay on price updates, making instantaneous manipulation possible.
    ❗ Attackers exploit atomicity of Ethereum transactions, manipulating prices and draining assets before the protocol can react.