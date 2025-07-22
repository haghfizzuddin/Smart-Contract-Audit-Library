# 📝 Wallet Drainer Phishing Audit

## 📌 Summary
This audit demonstrates a phishing scam pattern where users unknowingly approve unlimited token allowances to scammer addresses via misleading functions.

---

## ❌ Issue: Hidden Token Approval
```solidity
token.approve(scammer, type(uint256).max);
