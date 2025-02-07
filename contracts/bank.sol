// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    // Struct to store account info
    struct Account {
        string name;
        uint256 accountNumber;
        uint256 balance;
        uint256 pin;
        bool exists;
    }

    // Mapping to store user account by account number
    mapping(uint256 => Account) public accounts;

    // Event for account creation
    event AccountCreated(uint256 indexed accountNumber, string name);

    // Event for deposit transactions
    event Deposited(uint256 indexed accountNumber, uint256 amount);

    // Event for withdrawal transactions
    event Withdrawn(uint256 indexed accountNumber, uint256 amount);

    // Create a new account with name, account number, initial balance, and pin
    function createAccount(
        string memory _name,
        uint256 _accountNumber,
        uint256 _initialDeposit,
        uint256 _pin
    ) public {
        // Ensure the account doesn't already exist
        require(!accounts[_accountNumber].exists, "Account already exists");

        // Create the account
        accounts[_accountNumber] = Account({
            name: _name,
            accountNumber: _accountNumber,
            balance: _initialDeposit,
            pin: _pin,
            exists: true
        });

        // Emit an event for account creation
        emit AccountCreated(_accountNumber, _name);
    }

    // Function to deposit funds into an account
    function deposit(uint256 _accountNumber, uint256 _amount) public {
        // Ensure the account exists
        require(accounts[_accountNumber].exists, "Account does not exist");

        // Update the balance of the account
        accounts[_accountNumber].balance += _amount;

        // Emit an event for the deposit
        emit Deposited(_accountNumber, _amount);
    }

    // Function to withdraw funds from an account (requires correct PIN)
    function withdraw(uint256 _accountNumber, uint256 _amount, uint256 _pin) public {
        // Ensure the account exists
        require(accounts[_accountNumber].exists, "Account does not exist");

        // Ensure the PIN matches
        require(accounts[_accountNumber].pin == _pin, "Incorrect PIN");

        // Ensure there are sufficient funds in the account
        require(accounts[_accountNumber].balance >= _amount, "Insufficient funds");

        // Update the balance after withdrawal
        accounts[_accountNumber].balance -= _amount;

        // Emit an event for the withdrawal
        emit Withdrawn(_accountNumber, _amount);
    }

    // Function to check account balance
    function checkBalance(uint256 _accountNumber , uint _pin) public view returns (uint256) {
        // Ensure the account exists
        require(accounts[_accountNumber].exists, "Account does not exist");

        //ensure the provided pin matches the stored pin
        require(accounts[_accountNumber].pin == _pin, "Incorrect PIN");

        // Return the balance of the account
        return accounts[_accountNumber].balance;
    }
}
