# Smart Contract Audit Library

A practical library of smart contract security audit modules designed to demonstrate common Web3 vulnerabilities, exploit PoCs, and secure mitigation patterns — fully tested using Foundry.

---

## Overview

This repository contains modular audit examples, each structured to:
- Demonstrate a vulnerability via an isolated exploit proof-of-concept (PoC)
- Provide a fixed version demonstrating proper mitigation
- Include Foundry test cases for both the exploit and the secure fix
- Serve as a **practical reference** for Web3 security engineers

---

## Audit Modules Included

| Module | Description |
|---------|-------------|
| **ERC20 Unlimited Mint** | Shows how unrestricted minting breaks tokenomics and how to restrict it using OpenZeppelin `Ownable`. |
| **Reentrancy Exploit** | Classic reentrancy attack with fallback exploit and safe mitigation using `nonReentrant` guard. |
| **Access Control Bypass** | Demonstrates how poor access control enables unauthorized state changes; fixed with proper ownership checks. |
| **Wallet Drainer Phishing** | Simulates phishing-style wallet drainer using `approve()` and `transferFrom()` logic. |
| **Oracle Price Manipulation** | Demonstrates how price manipulation via balanceOf-based oracles enables borrowing abuse; fixed with static pricing. |

---

## How to Run Tests

```bash
forge install
forge test -vvv


## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
