## Writing Smart Contracts in Solidity

Getting our hands dirty with some Solidity

---

Be sure to test out all this code for yourself in [Remix IDE](https://remix.ethereum.org/).

---

## Essential Syntax

---

### License Identifier (optional)

```solidity
// SPDX-License-Identifier: <license-identifier-here>
// ex. SPDX-License-Identifier: MIT
// ex. SPDX-License-Identifier: GPL-3.0-or-later
// ex. SPDX-License-Identifier: UNLICENSED
```

---

### Solidity Language Version

```solidity
pragma solidity ^0.8.4;
```

[Version selection syntax](https://docs.npmjs.com/cli/v6/using-npm/semver)

---

### Contract Declaration

```solidity
contract MyContractName {
    // ...
}
```

---

### Data Types

`bool`, `[u]int[8-256]`, `address [payable]`, `bytes[1-32]`, `string`, `mapping`, enums, contracts, arrays, structs

_no undefined or null values_

_no floating-point numbers_

---

### Access Modifiers

`public`, `private`, `internal`, `external`

---

### View Modifier

Indicates the function does not modify state

---

### Pure Modifier

Indicates the function does not access or modify state

---

### Globals

`msg.sender`, `msg.value`, `tx.origin`, `require(...)`, `keccak256(...)`, `sha256(...)`, `block.timestamp`, `block.number`, `blockhash(...)`

[More](https://docs.soliditylang.org/en/v0.8.4/cheatsheet.html#global-variables)

---

### Gas

The cost of running code on the blockchain

---

Regular ETH transfer costs 21,000 gas

---

If the gas price is 66 Gwei (0.000000066 ETH)

21,000 &times; 0.000000066 ETH = 0.001386 ETH

<span>$</span>3.82 @ <span>$</span>2,756.35/ETH

---

#### Keeping gas usage low

- Only compute what you absolutely have to
- Storage I/O is _expensive_, memory less so
- Be _very careful_ when writing looping or recursive logic

---

_\[exercises\]_

---

### Events

Consume little gas, make it easy to add hooks for off-chain logic

---

### Payable Functions

Send ether to a smart contract function

Value appears in `msg.value` in units of _wei_ (smallest, indivisible unit of Ethereum)

---

#### Attaching ETH to a message call

```solidity
myContract.myFunction{ value: 1 ether }(/* ... */);
```

---

Pay addresses

```solidity
(bool success,) = payableAddress.call{ value: 1 ether }("");
```

Use of `send` and `transfer` is somewhat discouraged due to fixed gas allocation

---

Change gas limit

```solidity
address.functionCall{ gas: 21000 }(/* ... */);
```

Again, fixed/hardcoded gas limits are discouraged

---

_\[exercises\]_

---

## Best Practices

Design patterns & security considerations

---

Constants prevent reading from storage

```solidity
uint256 constant minimumBuy = 1 gwei;
```

---

Function modifiers increase modularity and readability

```solidity
modifier onlyOwner() {
    require(owner() == msg.sender, "Caller is not the owner");
    _;
}
```

```solidity
function mint () external onlyOwner {
    // ...
}
```

---

### Receive & Fallback

```solidity
// No function keyword
receive () external payable {
    // Called when the contract address is paid directly
    // Just like any other payable function
    // Keep in mind the gas limit could be as low as 2300
}
```

```solidity
// Optionally payable
fallback () external payable {
    // Called when no function signature matches
}
```

---

### Re-entrancy Vulnerability

1. _Contract A_ calls _Contract B_ before finishing setting its own state
2. _Contract B_ calls _Contract A_, taking advantage of _Contract A_'s invalid state

---

Use the **checks-effects-interactions** order of operations to prevent other contract calls from taking advantage of an invalid intermediate state.

---

_\[exercises\]_

---

## Project Status Update

Begin writing your smart contract(s)!

---

That's it!
