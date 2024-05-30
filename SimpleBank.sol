// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank {
    mapping(address => uint256) public balances;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        // Ensure deposit amount is non-zero
        require(msg.value > 0, "Deposit amount must be greater than zero");
        
        // Update balance
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) public {
        // Ensure the user has sufficient balance
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Check for overflow (should never happen)
        assert(balances[msg.sender] - _amount <= balances[msg.sender]);

        // Update balance
        balances[msg.sender] -= _amount;

        // Transfer Ether back to the user
        payable(msg.sender).transfer(_amount);
    }

    function emergencyWithdraw() public {
        // Only owner can perform emergency withdrawal
        if (msg.sender != owner) {
            revert("Only the owner can perform emergency withdrawal");
        }

        // Get contract balance
        uint256 contractBalance = address(this).balance;

        // Check for non-zero balance
        require(contractBalance > 0, "No funds available for withdrawal");

        // Transfer all funds to owner
        payable(owner).transfer(contractBalance);
    }

    function checkBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
