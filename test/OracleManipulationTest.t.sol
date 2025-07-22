// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/vulnerable/OracleVulnerableLending.sol";
import "../contracts/fixed/OracleSafeLending.sol";
import "../contracts/mocks/DummyToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OracleManipulationTest is Test {
    DummyToken collateral;
    DummyToken loan;
    DummyToken oracle;
    OracleVulnerableLending vulnerable;
    OracleSafeLending safe;
    address attacker;

    function setUp() public {
        collateral = new DummyToken("Collateral", "COLL");
        loan = new DummyToken("Loan", "LOAN");
        oracle = new DummyToken("Oracle", "ORCL");

        vulnerable = new OracleVulnerableLending(address(collateral), address(loan), address(oracle));
        safe = new OracleSafeLending(address(collateral), address(loan), 10); // fixed price

        attacker = address(0xBAD);
        loan.mint(address(vulnerable), 1000 ether);
        loan.mint(address(safe), 1000 ether);
    }

    function testExploitOracleManipulation() public {
        vm.startPrank(attacker);

        oracle.mint(attacker, 50 ether); // Inflated oracle balance
        collateral.mint(attacker, 500 ether);
        collateral.approve(address(vulnerable), type(uint256).max);

        vulnerable.borrow(15 ether); // Increased borrow for visible profit

        vm.stopPrank();

        assertGe(loan.balanceOf(attacker), 15 ether, "Attacker drained loanToken via oracle manipulation");
    }

    function testSafeLendingBlocksExploit() public {
        vm.startPrank(attacker);

        collateral.mint(attacker, 500 ether);
        collateral.approve(address(safe), type(uint256).max);

        vm.expectRevert();
        safe.borrow(100 ether);

        vm.stopPrank();
    }
}

// This test suite demonstrates how the vulnerable lending contract can be exploited through oracle manipulation,
// while the safe lending contract prevents such exploits by using a fixed price for borrowing.
// The test cases simulate an attacker manipulating the oracle to borrow more tokens than they should,
// and verifies that the safe lending contract blocks such attempts by requiring a fixed collateral amount.
// Users should always prefer safe lending contracts that do not rely on external oracles for critical operations
// to avoid potential exploits and losses
