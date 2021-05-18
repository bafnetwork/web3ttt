---
title: '02 - Exploring Smart Contracts'
description: 'Diving into some real-life smart contracts!'
categories: ['lesson']
tags: ['smart contract', 'etherscan.io', 'fungibility', 'erc20', 'erc721']
outputs: ['html', 'slides']
---

## Smart Contracts in Practice

Before we dive into writing smart contracts of our own, let's take a look at some of the simpler contracts that are alive and well on the Ethereum blockchain today. Many of these contracts implement another currency or token on top of Ethereum, and are therefore often called "Ethereum (based) tokens". Because this use case is so popular, there are a few different token standards that have arisen and gained popularity.

These standards merely formalize requirements for a contract's behavior and interface, so they don't (necessarily) provide or require any precise *implementation* of logic in order for the contract to conform to the specification. Think of these standards more like official interface definitions (like Java interfaces).

By far, the two most well-known token standards are [ERC-20](https://eips.ethereum.org/EIPS/eip-20) and [ERC-721](https://eips.ethereum.org/EIPS/eip-721).[^erc-meaning] These standards are the most popular for Ethereum-based fungible and non-fungible tokens, respectively.

[^erc-meaning]: ERC: **E**thereum **R**equest for **C**omments

### Fungibility

**Fungibility** is a property of an asset that describes its interchangability.

If the asset is **fungible**, that means that it can be replaced with another of the same type of asset and no value will be lost or gained. A fungible asset would be like a dollar: it doesn't matter *which* dollar you have---one dollar is one dollar. In other words, when dealing with fungible assets, what matters is *quantity*.

**Non-fungible** assets, on the other hand, are not universally mutually equivalent. Instead, a non-fungible asset is unique from all of the other assets, and *which* assets you own matters. A non-fungible asset would be like a piece of artwork: it matters *significantly* what you own---who created it, when, what media, whether it is an original, etc. This means that the *quality* of non-fungible assets you own usually matters more than the quantity.

## ERC-20: Fungible Tokens

An ERC-20 token contrect provides an interface to a fungible token. This means that an Ethereum address can be associated with a number of tokens of which the contract considers that address to be the owner. The smart contract maintains the collection of address-balance associations and provides a set of public operations that can be performed on it.

Some of the operations provided by an ERC-20 token contract include:

* `name` -- Returns the name of the contract's token
* `totalSupply` -- Returns the total number of tokens managed by the contract
* `transfer` -- Transfers a quantity of tokens from one address to another address
* `balanceOf` -- Returns the number of tokens owned by an address

### Sample ERC-20 Implementations

* [OpenZeppelin ERC-20](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol)

### Live ERC-20 Contracts

Note: These contracts were selected for their relative simplicity and readability. We do not endorse any of these tokens or projects.

* [VSL token](https://etherscan.io/address/0xDb144CD0F15eE40AaC5602364B470d703d7e16b6#code) (dead project)[^not-an-endorsement]
* [ENJ token](https://etherscan.io/address/0xf629cbd94d3791c9250152bd8dfbdf380e2a3b9c#code) and [security audit](https://callisto.network/enjin-token-enj-security-audit/)[^not-an-endorsement]

[^not-an-endorsement]: Not an endorsement of this project or its practices.

### ERC-20 Security

* [Allowance Double Withdrawal Attack](https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit)
