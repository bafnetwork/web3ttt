---
title: '03 - Writing Smart Contracts in Solidity'
description: 'Getting our hands dirty with some Solidity'
categories: ['lesson']
tags: ['smart contract', 'solidity', 'gas', 'wei', 'gwei', 'remix']
outputs: ['html', 'slides']
katex: true
---

Follow along in [Remix IDE](https://remix.ethereum.org/).

## Essential Syntax

### Listing

```solidity
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
        // Failed calls to require() revert the transaction, undoing state
        // changes
        require(_amount > 0, "Amount must be nonzero");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
```

### Concepts

Executing code on the blockchain costs money, and it's paid for in Ethereum. The network defines a unit called **gas**, which is set to some amount of ETH. Executing code on the Ethereum network takes some amount of gas. For example, a regular old ETH transfer transaction takes 21,000 gas. The more complex a contract's logic, the more gas it will take, and therefore, the more expensive it will be to call that contract.

Some general rules to keep your gas usage low:

- Only compute what you absolutely have to
- Storage I/O is *expensive*, memory less so
- Be *very careful* when writing looping or recursive logic

Some recent values for example:

Gas price: 66 Gwei (0.000000066 ETH) \
Gas for transaction: 21,000 \
Transaction fee: 21,000 &times; 0.000000066 ETH = 0.001386 ETH (<span>$</span>3.82 @ <span>$</span>2,756.35/ETH)

### Exercises

1. Create a `gift(address, uint256)` function that adds an amount to anyone's balance, and rewards the gifter with a call to the `mint()` function
    - Make sure to update `totalSupply`.
    - What modifiers should the function have?
2. The transfer function could use less gas while having the same functionality. What improvements can you make?
    - Optimization 1:
      - [Hint 1](https://docs.soliditylang.org/en/v0.8.4/introduction-to-smart-contracts.html#storage-memory-and-the-stack)
    - Optimization 2:
      - [Hint 1](https://docs.soliditylang.org/en/v0.8.4/080-breaking-changes.html#silent-changes-of-the-semantics)
      - [Hint 2](https://docs.soliditylang.org/en/v0.8.4/control-structures.html#checked-or-unchecked-arithmetic)
    - If you need help, check out [this transfer function from an OpenZeppelin ERC-20 implementation](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/5f50b9f6e02c6a8ce8fc4b243fdbbf210b0e6446/contracts/token/ERC20/ERC20.sol#L215).

## Payable Functions

### Listing

```solidity
pragma solidity ^0.8.4;

contract VeryExpensiveToken {
    mapping (address => uint256) public balances;
    uint256 public totalSupply = 0;
    // ETH can be sent to payable addresses
    address payable public owner;
    
    // Called when the contract is first deployed
    constructor (address payable _owner) {
        owner = _owner;
    }
    
    // Functions marked payable have access to msg.value, which is a quantity of
    // ETH tokens sent along with the function call
    function buy () external payable {
        uint256 _totalSupply = totalSupply;
        require(msg.value >= _nextTokenCost(_totalSupply),
            "Not enough to buy next token");
        totalSupply = _totalSupply + 1;
        balances[msg.sender]++;
    }
    
    function nextTokenCost () external view returns (uint256) {
        return _nextTokenCost(totalSupply);
    }
    
    // Pure functions cannot modify state, like view functions, but it also
    // cannot read state either
    function _nextTokenCost (uint256 _totalSupply) public pure returns (uint256) {
        // There are some nice keywords for pecuniary numbers in Solidity:
        //   1 wei == 1
        //   1 gwei == 1e9
        //   1 ether == 1e18
        // Also for durations:
        //   1 seconds == 1
        //   minutes, hours, days, weeks
        return (2 ** _totalSupply) * 1 ether;
    }
    
    function withdraw () public {
        assert(msg.sender == owner);

        // Although .send() and .transfer() functions exist for sending ETH,
        // their use is no longer recommended because they rely on a constant
        // gas cost for computations which is no longer a safe assumption
        // https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now
        (bool success,) = owner.call{ value: address(this).balance }("");
        require(success, "Withdraw failed");
    }
    
    function balanceOf (address _wallet) external view returns (uint256) {
        return balances[_wallet];
    }
    
    function transfer (address _to, uint256 _amount) public {
        // ...
    }
}
```

### Concepts

Payable functions are able to receive ETH tokens. The payment value is in the `msg.value` global in units of **wei**, the smallest division of Ethereum (1 ether = $10^{18}$ wei).

### Exercises

1. Create a `buyOut()` function which changes the owner to `msg.sender` if `(2 ** (2 * totalSupply)) * 1 ether` tokens are attached.
    - Implement the buyout value as a pure function.
    - Make sure to handle payouts to the old owner correctly!
    - `address(this).balance` is increased by `msg.value` before execution begins.
2. Read [this section in the Solidity documentation](https://docs.soliditylang.org/en/v0.8.4/common-patterns.html#withdrawal-from-contracts). Rewrite `buyOut()` with these considerations.
