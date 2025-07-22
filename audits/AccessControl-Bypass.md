# 📝 Access Control Bypass Audit

## 📌 Summary
This audit highlights a critical access control vulnerability where sensitive functions can be called by any address, allowing unauthorized state changes.

---

## ❌ Vulnerabilities Found

### 1. Lack of Access Restriction
```solidity
function updatePrivilegedData(uint256 _newData) public {
