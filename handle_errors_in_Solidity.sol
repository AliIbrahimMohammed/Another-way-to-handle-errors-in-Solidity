pragma solidity ^0.8.0;

contract Example {
    mapping(address => uint) public balances;

    function deposit(uint _amount) public {
        require(_amount > 0, "Amount must be greater than zero.");
        balances[msg.sender] += _amount;
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance.");
        require(_amount > 0, "Amount must be greater than zero.");
        msg.sender.transfer(_amount);
    }
}
In this example, the deposit() function uses the require() function to ensure that the amount being deposited is greater than 0. If the condition is not met, the function will revert and the message "Amount must be greater than zero." will be emitted.
Similarly, in the withdraw function, the require function is used to check if the user has sufficient balance and if the amount is greater than 0, if not it will revert the transaction and throw an error message "Insufficient balance." or "Amount must be greater than zero."

It's important to note that the require() function reverts the entire transaction and all changes made to the contract's state. This is different from the assert() function, which is similar but instead of reverting the transaction, it throws an exception and the changes made to the state will remain.

You can use require statement in many other scenarios like checking if the msg.sender has the permission.

pragma solidity ^0.8.0;

contract Example {
    mapping(address => uint) public balances;

    function deposit(uint _amount) public {
        require(_amount > 0, "Amount must be greater than zero.");
        try {
            // Execute critical code
            balances[msg.sender] += _amount;
        } catch (error) {
            // Handle error
            revert("An error occurred: " + error);
        }
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance.");
        require(_amount > 0, "Amount must be greater than zero.");
        try {
            // Execute critical code
            msg.sender.transfer(_amount);
        } catch (error) {
            // Handle error
            revert("An error occurred: " + error);
        }
    }
}


In this example, the deposit() and withdraw() functions use the try-catch pattern to handle any errors that may occur during the execution of the critical code. The try block is used to execute the critical code, and if an error occurs, the catch block is executed and the transaction is reverted with a message indicating that an error occurred.

You can also use try-catch pattern to catch specific errors. For example, instead of catching all errors, you can catch an error for a specific exception type.

It's important to note that the try-catch pattern is only available in Solidity versions 0.5.0 and above.

It's always a good practice to handle errors and provide helpful error messages to users, it will help them to understand what went wrong and also it will help you to debug your smart contract if something goes wrong.

pragma solidity ^0.8.0;

contract Example {
    enum ErrorCodes {SUCCESS, ERROR_AMOUNT_ZERO, ERROR_INSUFFICIENT_BALANCE}

    mapping(address => uint) public balances;

    function deposit(uint _amount) public returns (ErrorCodes) {
        if (_amount == 0) {
            return ErrorCodes.ERROR_AMOUNT_ZERO;
        }
        balances[msg.sender] += _amount;
        return ErrorCodes.SUCCESS;
    }

    function withdraw(uint _amount) public returns (ErrorCodes) {
        if (_amount == 0) {
            return ErrorCodes.ERROR_AMOUNT_ZERO;
        }
        if (balances[msg.sender] < _amount) {
            return ErrorCodes.ERROR_INSUFFICIENT_BALANCE;
        }
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        return ErrorCodes.SUCCESS;
    }
}


In this example, the deposit() and withdraw() functions use an enumeration (enum) to define a set of error codes. Each function checks for specific conditions and returns the appropriate error code if an error occurs. This allows the client-side code to easily check the returned error code and handle the error accordingly. This pattern is more flexible as it allows you to handle a variety of different error scenarios.

It's also a good practice to provide helpful comments for each error code, so that other developers who read the code can understand the meaning of each error code.

Keep in mind that any error handling method you choose, it should be simple, easy to understand, and testable.

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";

contract Example {
    using SafeMath for uint256;

    mapping(address => uint256) public balances;

    function deposit(uint256 _amount) public {
        balances[msg.sender] = balances[msg.sender].add(_amount);
    }

    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        msg.sender.transfer(_amount);
    }
}


In this example, the "Safe Math" library is imported and used to handle mathematical operations. The "add" and "sub" functions automatically check for overflow and underflow errors and revert the transaction if an error occurs. This reduces the need for manual error checking and improves the security of your contract.

It's important to note that "Safe Math" libraries are not bulletproof and may not cover every possible edge case, so it's still important to thoroughly test your contract and use other error handling methods as well.

OpenZeppelin is a widely used and battle-tested library for Ethereum smart contracts development, it provides a lot of useful libraries and functions, SafeMath is one of them, it's a good practice to use it in your smart contract development.

pragma solidity ^0.8.0;

contract Example {
    mapping(address => uint) public balances;

    event Error(string message);

    function deposit(uint _amount) public {
        require(_amount > 0, "Amount must be greater than zero.");
        balances[msg.sender] += _amount;
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance.");
        require(_amount > 0, "Amount must be greater than zero.");
        msg.sender.transfer(_amount);
    }

    function transfer(address _to, uint _value) public {
        require(_to != address(0), "Invalid address.");
        require(balances[msg.sender] >= _value, "Insufficient balance.");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }
}


In this example, the deposit() and withdraw() functions use the "require" statement to check for specific conditions. If the conditions are not met, the transaction is reverted and an event called "Error" is emitted with a message indicating the error that occurred.

This allows external clients and auditing tools to listen for these events and track errors that occur in the smart contract. This can be useful for debugging and auditing purposes.

It's important to note that the "require" statement with the "emit" statement is not a replacement for other error handling methods, but it can be used in addition to them to provide additional visibility and tracking of errors that occur in the smart contract.

pragma solidity ^0.8.0;

contract Example {
    mapping(address => uint) public balances;

    function deposit(uint _amount) public {
        assert(_amount > 0, "Amount must be greater than zero.");
        balances[msg.sender] += _amount;
    }

    function withdraw(uint _amount) public {
        assert(balances[msg.sender] >= _amount, "Insufficient balance.");
        assert(_amount > 0, "Amount must be greater than zero.");
        msg.sender.transfer(_amount);
    }

    function transfer(address _to, uint _value) public {
        assert(_to != address(0), "Invalid address.");
        assert(balances[msg.sender] >= _value, "Insufficient balance.");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
    }
}


In this example, the deposit(), withdraw() and transfer() functions use the "assert" statement to check for specific conditions. If the conditions are not met, the transaction is reverted and the error message is provided.

It's important to note that the "assert" statement should only be used to test for errors that should never occur, it's not recommended to use it to handle errors that can occur in normal operation, such as user input errors.

