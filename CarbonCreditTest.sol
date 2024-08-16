// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "remix_tests.sol"; // Import Remix testing library
import "./CarbonCredit.sol"; // Import the contract to be tested

contract CarbonCreditTest {
    CarbonCredit carbonCredit;

    address owner = address(this); // Use this contract as the owner

    // Before each test, deploy a new instance of the CarbonCredit contract
    function beforeEach() public {
        carbonCredit = new CarbonCredit();
    }

    // Test issuing a new carbon credit
    function testIssueCredit() public {
        carbonCredit.issueCredit("Carbon Credit A", 10);

        (string memory description, uint256 amount, address creditOwner) = carbonCredit.getCredit(0);

        Assert.equal(description, "Carbon Credit A", "Description should match");
        Assert.equal(amount, 10, "Amount should match");
        Assert.equal(creditOwner, owner, "Owner should match");
    }

    // Test transferring a carbon credit
    function testTransferCredit() public {
        carbonCredit.issueCredit("Carbon Credit B", 20);

        address newOwner = address(0x123);

        carbonCredit.transferCredit(0, newOwner);

        (, , address creditOwner) = carbonCredit.getCredit(0);

        Assert.equal(creditOwner, newOwner, "Owner should match the new address");
    }

    // Test failure case: transfer credit without ownership
    function testFailTransferCreditWithoutOwnership() public {
        carbonCredit.issueCredit("Carbon Credit C", 30);

        // Attempt to transfer the credit from a different address
        address nonOwner = address(0x456);

        // Use assertFail to expect a revert due to lack of ownership
        try carbonCredit.transferCredit(0, nonOwner) {
            Assert.ok(false, "Expected transfer to fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Only the owner can transfer this credit", "Revert reason should match");
        }
    }

    // Test failure case: invalid address for transfer
    function testFailTransferCreditToInvalidAddress() public {
        carbonCredit.issueCredit("Carbon Credit D", 40);

        // Attempt to transfer to the zero address
        try carbonCredit.transferCredit(0, address(0)) {
            Assert.ok(false, "Expected transfer to fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Invalid address", "Revert reason should match");
        }
    }
}
