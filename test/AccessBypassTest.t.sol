// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/vulnerable/AccessBypassExample.sol";
import "../contracts/fixed/SecureAccessExample.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AccessBypassTest is Test {
    AccessBypassExample public vulnerable;
    SecureAccessExample public fixedContract;

    function setUp() public {
        vulnerable = new AccessBypassExample();
        fixedContract = new SecureAccessExample();
    }

    function testBypassAccessControl() public {
        vulnerable.updatePrivilegedData(777);
        assertEq(vulnerable.privilegedData(), 777, "Unauthorized update succeeded");
    }

    function testAccessControlPreventsUnauthorizedUpdate() public {
        address attacker = address(0xBEEF);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                attacker
            )
        );
    vm.prank(attacker);
    fixedContract.updatePrivilegedData(999);
    }

}
// Note: This test suite checks for access bypass vulnerabilities in the AccessBypassExample contract.
// It ensures that the vulnerable contract allows unauthorized updates, while the fixed contract prevents them using OpenZeppelin's Ownable contract.
// The testAccessControlPreventsUnauthorizedUpdate function verifies that only the owner can update privileged data in the SecureAccessExample contract, preventing unauthorized access.