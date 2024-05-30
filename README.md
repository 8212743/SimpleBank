# SimpleBank Smart Contract

## Overview

SimpleBank is a basic Ethereum smart contract that allows users to deposit and withdraw Ether. The contract maintains a balance for each user and includes an emergency withdrawal function for the owner.

## Features

- **Deposit Ether**: Users can deposit Ether into the contract, which will be recorded in their balance.
- **Withdraw Ether**: Users can withdraw their Ether balance from the contract.
- **Emergency Withdraw**: The owner of the contract can withdraw all funds in case of an emergency.
- **Check Balance**: Users can check their balance.

## Prerequisites

- Solidity ^0.8.0
- An Ethereum wallet (e.g., MetaMask)
- An Ethereum development environment (e.g., Remix, Truffle)

## Contract Details

### State Variables

- `balances`: A mapping that stores the Ether balance for each user.
- `owner`: The address of the contract owner.

### Constructor

The constructor initializes the `owner` variable with the address that deploys the contract.

```solidity
constructor() {
    owner = msg.sender;
}
```

### Functions

#### `deposit()`

Allows users to deposit Ether into the contract. The deposited amount must be greater than zero.

```solidity
function deposit() public payable {
    require(msg.value > 0, "Deposit amount must be greater than zero");
    balances[msg.sender] += msg.value;
}
```

#### `withdraw(uint256 _amount)`

Allows users to withdraw a specified amount of Ether from their balance. The user must have sufficient balance.

```solidity
function withdraw(uint256 _amount) public {
    require(balances[msg.sender] >= _amount, "Insufficient balance");
    assert(balances[msg.sender] - _amount <= balances[msg.sender]);
    balances[msg.sender] -= _amount;
    payable(msg.sender).transfer(_amount);
}
```

#### `emergencyWithdraw()`

Allows the owner to withdraw all funds from the contract. This function can only be called by the owner.

```solidity
function emergencyWithdraw() public {
    if (msg.sender != owner) {
        revert("Only the owner can perform emergency withdrawal");
    }
    uint256 contractBalance = address(this).balance;
    require(contractBalance > 0, "No funds available for withdrawal");
    payable(owner).transfer(contractBalance);
}
```

#### `checkBalance()`

Returns the balance of the user calling the function.

```solidity
function checkBalance() public view returns (uint256) {
    return balances[msg.sender];
}
```

## Usage

1. **Deploy the Contract**: Deploy the `SimpleBank` contract to an Ethereum network.
2. **Deposit Ether**: Call the `deposit` function and send Ether along with the transaction.
3. **Withdraw Ether**: Call the `withdraw` function with the desired amount to withdraw.
4. **Emergency Withdraw**: The owner can call the `emergencyWithdraw` function to withdraw all funds from the contract.
5. **Check Balance**: Call the `checkBalance` function to view the user's balance.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Security Considerations

- Ensure the contract is deployed by the intended owner.
- The owner should securely manage the private key associated with the owner address.
- Be aware of potential reentrancy attacks; this contract is simplified and does not include protection mechanisms like reentrancy guards.

## Disclaimer

This contract is provided as-is for educational purposes. It has not been audited, and deploying it on a mainnet or handling significant amounts of Ether is not recommended without further security review.
