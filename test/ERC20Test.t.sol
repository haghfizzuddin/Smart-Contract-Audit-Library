// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/vulnerable/BasicERC20.sol";
import "../contracts/fixed/FixedERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Test is Test {
    BasicERC20 token;
    FixedERC20 fixedToken;

    function setUp() public {
        token = new BasicERC20();
        fixedToken = new FixedERC20();
    }

    function testPublicMintExploitation() public {
        token.mint(address(this), 1000000 ether);
        assertEq(token.balanceOf(address(this)), 1000000 ether);
    }

    function testUnauthorizedMintFails() public {
        address attacker = address(0xBEEF);

        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, attacker));
        vm.prank(attacker);
        fixedToken.mint(address(this), 1000000 ether);
    }
}
