---
title: '03 - Writing Smart Contracts in Solidity'
description: 'Getting our hands dirty with some Solidity'
categories: ['lesson']
tags: ['smart contract', 'solidity', 'gas', 'wei', 'gwei', 'remix']
outputs: ['html', 'slides']
katex: true
links:
  - name: Recording
    url: https://www.youtube.com/watch?v=K82Jp8zq9f4
---

Follow along in [Remix IDE](https://remix.ethereum.org/). Copy and paste the listings, deploy and test your solutions to the exercises.

## Essential Syntax

### Listing

[View on GitHub](https://github.com/bafnetwork/web3ttt/blob/main/examples/03/01_FreeToken.sol)

```solidity {linenos=true}
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
- Storage I/O is _expensive_, memory less so
- Be _very careful_ when writing looping or recursive logic

Some recent values for example:

Gas price: 66 Gwei (0.000000066 ETH) \
Gas for transaction: 21,000 \
Transaction fee: 21,000 &times; 0.000000066 ETH = 0.001386 ETH (<span>$</span>3.82 @ <span>$</span>2,756.35/ETH)

### Exercises

1. Create a `gift(address, uint256)` function that adds an amount to anyone's balance, and rewards the gifter with a call to the `mint()` function
   - Make sure to update `totalSupply`.
   - What modifiers should the function have?
2. The transfer function could use less gas while having the same functionality. What improvements can you make?
   - Implementing these two optimizations improved the execution cost of the function from 28847 gas to 12777 gas (55.7% improvement).
   - Optimization 1:
     - Involves reading from storage
     - [Hint 1](https://docs.soliditylang.org/en/v0.8.4/introduction-to-smart-contracts.html#storage-memory-and-the-stack)
   - Optimization 2:
     - Involves integer overflow safeguards
     - [Hint 1](https://docs.soliditylang.org/en/v0.8.4/080-breaking-changes.html#silent-changes-of-the-semantics)
     - [Hint 2](https://docs.soliditylang.org/en/v0.8.4/control-structures.html#checked-or-unchecked-arithmetic)
   - If you need help, check out [this transfer function from an OpenZeppelin ERC-20 implementation](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/5f50b9f6e02c6a8ce8fc4b243fdbbf210b0e6446/contracts/token/ERC20/ERC20.sol#L215).

## Payable Functions

### Listing

[View on GitHub](https://github.com/bafnetwork/web3ttt/blob/main/examples/03/02_VeryExpensiveToken.sol)

```solidity {linenos=true}
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

    // Events appear in logs (e.g. for debugging) and web3 applications can
    // listen for them
    // Indexed parameters are searchable in logs
    event BuyEvent(address indexed buyer, uint256 indexed tokenIndex, uint256 price);

    // Functions marked payable have access to msg.value, which is a quantity of
    // ETH tokens sent along with the function call
    function buy () external payable {
        uint256 _totalSupply = totalSupply;
        require(msg.value >= _nextTokenCost(_totalSupply),
            "Not enough to buy next token");
        totalSupply = _totalSupply + 1;
        balances[msg.sender]++;

        // Emits an event
        emit BuyEvent(msg.sender, _totalSupply, msg.value);
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
        // !!!WARNING!!!
        // There is potential for even worse bugs or vulnerabilities if this
        // method is not used carefully. Proper usage is covered in the next
        // section.
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

If you are short on gas and your logic can be performed off-chain somewhere, **events** are a relatively cheap (although not free) way to integrate off-chain logic into an application. Web3 applications can listen for events and react to them.

### Exercises

1. Create a `buyOut()` function which changes the owner to `msg.sender` if `(2 ** (2 + totalSupply)) * 1 ether` tokens are attached.
   - Implement the buyout value as a pure function.
   - Make sure to handle payouts to the old owner correctly!
   - Emit a (new) `BuyOutEvent` with the old and new owner indexed, and the buyout price.
   - `address(this).balance` is increased by `msg.value` before execution begins.
2. Read [this section in the Solidity documentation](https://docs.soliditylang.org/en/v0.8.4/common-patterns.html#withdrawal-from-contracts). Rewrite `buyOut()` with these considerations.

## Design Patterns & Security Considerations

### Listing

[View on GitHub](https://github.com/bafnetwork/web3ttt/blob/main/examples/03/03_InconspicuousToken.sol)

```solidity {linenos=true}
pragma solidity ^0.8.4;

contract InconspicuousToken {
    mapping (address => uint256) balances;
    uint256 public totalSupply = 0;
    // Constant values are defined at compile time and replaced throughout the
    // contract so they do not incur a storage read cost.
    uint256 constant minimumBuy = 1 gwei;

    function balanceOf (address _wallet) external view returns (uint256) {
        return balances[_wallet];
    }

    // Errors look a little bit like events, but they halt execution when used
    error InsufficientBuy();

    // Custom function modifiers alter function behavior
    modifier enforceMinimumBuy () {
        // Similar to a require(...) call
        if (msg.value < minimumBuy) {
            revert InsufficientBuy();
        }

        // Will be replaced with the modified function's body
        _;
    }

    function contractBalance () external view returns (uint256) {
        return address(this).balance;
    }

    // Uses a custom function modifier to ensure that a condition is met
    function buy () payable external enforceMinimumBuy {
        balances[msg.sender] += msg.value;
        totalSupply += msg.value;
    }

    function sell () external {
        // !!!WARNING!!!
        // This function is vulnerable!

        // Send the user their unwrapped funds
        uint256 balance = balances[msg.sender];
        (bool success,) = payable(msg.sender).call{
            value: balance
        }("");

        // Don't empty their wallet if the transaction failed
        if (success) {
            totalSupply -= balance;
            balances[msg.sender] = 0;
        }
    }

    function transfer (address _to, uint256 _amount) external {
        // ...
    }
}
```

### Concepts

#### Fallback & Receive Functions

Recall that any given Ethereum address may be controlled by a smart contract or a real person. Smart contracts can also respond to transactions sent directly to their address by using a special `fallback` or `receive` function. These functions look like this:

```solidity
// No function keyword
receive () external payable {
    // Called when the contract address is paid directly
    // Just like any other payable function
    // Keep in mind the gas limit could be as low as 2300
}

// Optionally payable
fallback () external payable {
    // Called when no function signature matches
}
```

See the documentation for [fallback functions](https://docs.soliditylang.org/en/v0.8.4/contracts.html#fallback-function) and [receive functions](https://docs.soliditylang.org/en/v0.8.4/contracts.html#receive-ether-function).

#### Cross-contract calls

Smart contracts can call each other if they know the address and interface of the contract they want to call. Fortunately, addresses aren't too difficult to discover, and a contract's interface can be easily imported into another file by using the `import` keyword:

```solidity
// At the top of the file
import "./InconspicuousToken.sol";

// Elsewhere in your contract...
InconspicuousToken it = InconspicuousToken(contractAddress);
it.buy{ value: /* ... */ }();
it.sell();
```

See [the documentation for import](https://docs.soliditylang.org/en/v0.8.4/layout-of-source-files.html#importing-other-source-files) and [more information about calling other contracts](https://ethereum.org/en/developers/tutorials/interact-with-other-contracts-from-solidity/).

#### Security Vulnerability: Re-entrancy

Sending ETH to an address has the potential to trigger some smart contract code---smart contract code which could theoretically call other smart contract code and so on and so forth.

This all brings us to a type of security vulnerability called **re-entrancy**, and as it turns out, the above listing is vulnerable to a re-entrancy attack.

The general idea of a re-entrancy attack is to call back into a contract while it is in the middle of executing (i.e. when it calls another contract), in order to take advantage of an invalid intermediate state.

#### Mitigation

Use the **checks-effects-interactions**[^cei] order of operations:

[^cei]: https://docs.soliditylang.org/en/v0.8.4/security-considerations.html#use-the-checks-effects-interactions-pattern

1. Check & validate your input
2. Perform any and all modifications to contract state
3. Send calls to other contracts

This ensures that your contract state will _always_ be valid when other contracts may be attempting to interact with it _even as part of one of your own function calls_.

### Exercises

1. Construct a contract that performs a re-entrancy attack on `InconspicuousToken`.
   - Your contract should contain four functions:
     - `contractBalance()` for figuring out if your attack worked
     - A `receive` function
     - `performAttack1(address)` which performs a buy on `InconspicuousToken`
     - `performAttack2(address)` which performs a sell on `InconspicuousToken`
   - The attack should drain the `InconspicuousToken`'s balance into the attacking contract's balance
2. Use the check-effects-interactions pattern to fix `InconspicuousToken`.

## Project Status Update

Begin writing the smart contract(s) for your project. Do not be afraid to use sources like [the OpenZeppelin contract library](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts) for help and inspiration. Remember to emit events for things that your web application will need to be aware of!
