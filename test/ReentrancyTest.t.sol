// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/vulnerable/ReentrancyVault.sol";
import "../contracts/vulnerable/MaliciousAttacker.sol";
import "../contracts/fixed/SafeVault.sol";

contract ReentrancyTest is Test {
    ReentrancyVault vault;
    SafeVault safeVault;
    MaliciousAttacker attacker;

    function setUp() public {
        vault = new ReentrancyVault();
        safeVault = new SafeVault();
        attacker = new MaliciousAttacker(address(vault));

        vm.deal(address(this), 10 ether);
    }

    function testReentrancyExploit() public {
        vault.deposit{value: 5 ether}();

        vm.deal(address(attacker), 1 ether);
        vm.prank(address(attacker));
        attacker.attack{value: 1 ether}();

        assertGt(address(attacker).balance, 1 ether, "Attacker drained funds");
        assertLt(vault.getBalance(), 5 ether, "Vault was drained");
    }

    function testSafeVaultBlocksReentrancy() public {
    safeVault.deposit{value: 5 ether}();
    uint256 vaultBalanceBefore = address(safeVault).balance;

    // Attacker setup targeting SafeVault
    address attackerEOA = address(0xBEEF);
    vm.deal(attackerEOA, 1 ether);

    // Direct low-level call from attacker address
    vm.prank(attackerEOA);
    (bool success, ) = address(safeVault).call(
        abi.encodeWithSignature("withdraw()")
    );

    // Expect no success, no reentrancy allowed
    assertTrue(!success, "Attack failed to execute withdraw");
    assertEq(safeVault.getBalance(), vaultBalanceBefore, "SafeVault retains full balance");
    }

}
