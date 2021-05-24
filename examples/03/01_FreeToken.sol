// SPDX-License-Identifier: <license-identifier-here>
// ex. SPDX-License-Identifier: MIT
// ex. SPDX-License-Identifier: GPL-3.0-or-later
// ex. SPDX-License-Identifier: UNLICENSED

// Solidity compiler version
// You can specify more precise version selection bounds by using the syntax
// here: https://docs.npmjs.com/cli/v6/using-npm/semver
pragma solidity ^0.8.4;

// Most of your code will live inside a contract declaration
contract FreeToken {
    // Solidity has a few unique data types, such as mapping, address
    // A mapping is like an associative array, dictionary, or hashmap
    // This mapping maps Ethereum addresses to 256-bit unsigned integers
    mapping (address => uint256) balances;
    
    // The public access modifier doesn't allow external code to write to this
    // value, only read
    uint256 public totalSupply = 0;
    
    // External functions can only be called from OUTSIDE the contract, and are
    // disallowed from making internal function calls. Public functions can do
    // both, but are more expensive.
    // This function doesn't modify the state of the contract, so it is marked
    // with the view modifier
    function balanceOf (address _wallet) external view returns (uint256) {
        return balances[_wallet];
    }
    
    // This function does modify the state of the contract, so no view modifier
    function mint () external {
        // msg.sender gives us the external address that initiated this call
        balances[msg.sender] += 1;
        totalSupply += 1;
    }
    
    // Could this function be improved?
    function transfer (address _to, uint256 _amount) external {
        // Failed calls to require() revert the transaction, undoing state changes
        require(_amount > 0, "Amount must be nonzero");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
    
    // Could this function be improved?
    function improvedTransfer (address _to, uint256 _amount) external {
        // Failed calls to require() revert the transaction, undoing state changes
        require(_amount > 0, "Amount must be nonzero");
        uint256 balance = balances[msg.sender];
        require(balance >= _amount, "Insufficient balance");
        
        unchecked {
            balances[msg.sender] = balance - _amount;
        }
        balances[_to] += _amount;
    }
}
