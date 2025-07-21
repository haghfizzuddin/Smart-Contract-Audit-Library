# 📝 ERC20 Token Smart Contract Audit

## 📌 Summary
Audit of a basic ERC20 token contract revealing misimplementation vulnerabilities common in beginner contracts, including minting controls and allowance manipulation.

---

## ❌ Vulnerabilities Found

### 1. Public Mint Function (Critical)
```solidity
function mint(address to, uint256 amount) public {
    _mint(to, amount);
}
