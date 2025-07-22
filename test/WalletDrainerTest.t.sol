// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/vulnerable/WalletDrainer.sol";
import "../contracts/fixed/SafeApprovalWallet.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DummyToken is ERC20 {
    constructor() ERC20("FakeToken", "FAKE") {
        // Remove minting to deployer, only use explicit mint()
    }
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract WalletDrainerTest is Test {
    DummyToken token;
    WalletDrainer drainer;
    SafeApprovalWallet safe;
    address victim;

    function setUp() public {
        token = new DummyToken();
        drainer = new WalletDrainer(address(token));
        safe = new SafeApprovalWallet(address(token));

        victim = address(0xBEEF);
        token.mint(victim, 100 ether);
        vm.deal(victim, 1 ether);
    }

    function testPhishingApproveScam() public {
        vm.startPrank(victim);
        // Victim clicks phishingApprove (social engineering)
        drainer.phishingApprove();
        // Victim is tricked into approving scammer
        token.approve(drainer.scammer(), type(uint256).max);
        vm.stopPrank();

        uint256 allowance = token.allowance(victim, drainer.scammer());
        assertEq(allowance, type(uint256).max, "Phishing approve succeeded");
    }

    function testTokenDrainViaTransferFrom() public {
        vm.startPrank(victim);
        drainer.phishingApprove();
        token.approve(drainer.scammer(), type(uint256).max);
        vm.stopPrank();

        address scammer = drainer.scammer();

        vm.startPrank(scammer);
        token.transferFrom(victim, scammer, 100 ether);
        vm.stopPrank();

        assertEq(token.balanceOf(scammer), 100 ether, "Scammer drained victim funds");
        assertEq(token.balanceOf(victim), 0, "Victim drained completely");
    }

    function testSafeWalletNoApprove() public {
        vm.startPrank(victim);
        safe.claimReward();
        vm.stopPrank();

        uint256 allowance = token.allowance(victim, address(safe));
        assertEq(allowance, 0, "Safe wallet does not hijack allowance");
    }
}


// This test suite is designed to validate the phishing vulnerability in the WalletDrainer contract.
// It simulates a scenario where a victim unknowingly approves a scammer to drain their tokens
// through a phishing contract. The test checks if the scammer can successfully gain approval
// and drain the victim's tokens, while also ensuring that the SafeApprovalWallet does not allow
// malicious approval logic. The SafeApprovalWallet is tested to confirm that it does not hijack
// approvals, providing a secure alternative to potentially harmful airdrop contracts.

// Note: This test suite checks for phishing vulnerabilities in the WalletDrainer contract.
// It ensures that the WalletDrainer contract tricks users into approving a scammer to spend their tokens.
// The testPhishingApproveScam function verifies that the scammer can gain approval to drain tokens,
// while the testSafeWalletNoApprove function confirms that the SafeApprovalWallet does not allow malicious approval logic.
// Users should be cautious and verify the legitimacy of airdrop contracts before approving token transfers.
// The SafeApprovalWallet serves as a secure alternative to potentially harmful airdrop contracts, preventing unauthorized token transfers.