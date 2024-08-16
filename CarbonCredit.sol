// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CarbonCredit {
    struct Credit {
        string description;
        uint256 amount;
        address owner;
    }

    Credit[] public credits;

    event CreditIssued(uint256 indexed creditId, string description, uint256 amount, address indexed owner);
    event CreditTransferred(uint256 indexed creditId, address indexed from, address indexed to);

    // Issue a new carbon credit
    function issueCredit(string memory description, uint256 amount) public {
        credits.push(Credit(description, amount, msg.sender));
        emit CreditIssued(credits.length - 1, description, amount, msg.sender);
    }

    // Get details of a specific carbon credit
    function getCredit(uint256 creditId) public view returns (string memory, uint256, address) {
        require(creditId < credits.length, "Credit does not exist");
        Credit memory credit = credits[creditId];
        return (credit.description, credit.amount, credit.owner);
    }

    // Transfer a carbon credit to a new owner
    function transferCredit(uint256 creditId, address newOwner) public {
        require(creditId < credits.length, "Credit does not exist");
        require(newOwner != address(0), "Invalid address");
        Credit storage credit = credits[creditId];
        require(msg.sender == credit.owner, "Only the owner can transfer this credit");

        credit.owner = newOwner;
        emit CreditTransferred(creditId, msg.sender, newOwner);
    }
}
