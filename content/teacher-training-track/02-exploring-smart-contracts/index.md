---
title: '02 - Exploring Smart Contracts'
description: 'Diving into some real-life smart contracts!'
categories: ['lesson']
tags: ['smart contract', 'fungibility', 'erc-20', 'erc-721']
outputs: ['html', 'slides']
---

## Smart Contracts in Practice

Before we dive into writing smart contracts of our own, let's take a look at some of the simpler contracts that are alive and well on the Ethereum blockchain today. Many of these contracts implement another currency or token on top of Ethereum, and are therefore often called "Ethereum (based) tokens". Because this use case is so popular, there are a few different token standards that have arisen and gained popularity.

These standards merely formalize requirements for a contract's behavior and interface, so they don't (necessarily) provide or require any precise _implementation_ of logic in order for the contract to conform to the specification. Think of these standards more like official interface definitions (like Java interfaces).

By far, the two most well-known token standards are [ERC-20](https://eips.ethereum.org/EIPS/eip-20) and [ERC-721](https://eips.ethereum.org/EIPS/eip-721).[^erc-meaning] These standards and their derivatives are the most popular for Ethereum-based fungible and non-fungible tokens, respectively.

[^erc-meaning]: ERC: **E**thereum **R**equest for **C**omments

### Fungibility

**Fungibility** is a property of an asset that describes its interchangability.

If the asset is **fungible**, that means that it can be replaced with another of the same type of asset and no value will be lost or gained. A fungible asset would be like a dollar: it doesn't matter _which_ dollar you have---one dollar is one dollar. In other words, when dealing with fungible assets, what matters is _quantity_.

**Non-fungible** assets, on the other hand, are not universally mutually equivalent. Instead, a non-fungible asset is unique from all of the other assets, and _which_ assets you own matters. A non-fungible asset would be like a piece of artwork: it matters _significantly_ what you own---who created it, when, what media, whether it is an original, etc. This means that the _quality_ of non-fungible assets you own usually matters more than the quantity.

## ERC-20: Fungible Tokens

An ERC-20 token contract provides an interface to a fungible token, associating Ethereum addresses with a quantity of tokens. The smart contract maintains the collection of address-balance associations and provides a set of public operations that can be performed on the collection.

Some of the operations provided by an ERC-20 token contract include:

- `name` -- Returns the name of the contract's token
- `totalSupply` -- Returns the total number of tokens managed by the contract
- `transfer` -- Transfers a quantity of tokens from one address to another address
- `balanceOf` -- Returns the number of tokens owned by an address

### Sample Implementations

- [OpenZeppelin ERC-20](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol)

### Live Contracts

Note: These contracts were selected for their relative simplicity and readability. We do not necessarily endorse any of these tokens or projects.

- [VSL token](https://etherscan.io/address/0xDb144CD0F15eE40AaC5602364B470d703d7e16b6#code) (dead project)[^not-an-endorsement]
- [ENJ token](https://etherscan.io/address/0xf629cbd94d3791c9250152bd8dfbdf380e2a3b9c#code) and [security audit](https://callisto.network/enjin-token-enj-security-audit/)[^not-an-endorsement]

### Issues

- [Allowance Double Withdrawal Attack](https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit)

## ERC-721: Non-fungible Tokens (NFT's)

An ERC-721 token contract provides an interface to an NFT token registry, wherein unique token identifiers are associated with their owner's ETH address. The public interface is reminiscent of some of the ERC-20 methods, with some interesting modifications and additions:

- `transferFrom` -- Transfers a single token from one address to another
- `ownerOf` -- Returns the address of the owner of a specific token

### Sample Implementations

- [OpenZeppelin ERC-721](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol)
- [0xcert nf-token](https://github.com/0xcert/ethereum-erc721/blob/master/src/contracts/tokens/nf-token.sol)

### Live Contracts

Note: These contracts were selected for their relative simplicity and readability. We do not necessarily endorse any of these tokens or projects.

- [This random NFT from Rarible](https://etherscan.io/address/0x0a59849de1e4bd9cb9fcfe303678523fba10de33#code), [original Rarible listing](https://rarible.com/rimowa_metaverse)[^not-an-endorsement]
- [VOXIES Token](https://etherscan.io/address/0xe3435edbf54b5126e817363900234adfee5b3cee#code)[^not-an-endorsement]

### Issues

- [General inefficiency](https://medium.com/alphawallet/epic-fail-the-consequences-of-poor-erc-design-what-you-can-do-about-it-503e19c750)

## Other Contracts

- [DoubleOrNothing](https://etherscan.io/address/0x66d58f0a2a44742688843ceb8c0fa8d8567e3c54#code)[^not-an-endorsement]
- [The Hitchhiker's Guide to the Galaxy (H2G2)](https://etherscan.io/address/0xb957d92d7feae5be6877aa94997de6dcd36b65f4#code)[^not-an-endorsement]
- [NEXO Token](https://etherscan.io/address/0xb62132e35a6c13ee1ee0f84dc5d40bad8d815206#code)[^not-an-endorsement]

[^not-an-endorsement]: Not an endorsement of this project or its practices.

## Project Status Update

Given some of these example smart contracts, you should start thinking about what you might want your project to look like. You project must contain a smart contract and web front-end at least. It does not have to be complicated, but it should be usable by a general audience. Here are some more ideas for consideration:

- Identity management (cf. [Unstoppable Domains](https://unstoppabledomains.com/))
- Lottery
- Voting systems
- Auction
- Savings account/loans
- Integration with website (such as [r/CryptoCurrency MOON](https://www.reddit.com/r/CryptoCurrency/))
- Escrow (mediate payments between two parties)
- NFT collectibles game (à la [CryptoKitties](https://www.cryptokitties.co/) or similar marketplace ([Rarible](https://rarible.com/), [SuperRare](https://www.superrare.co/)))
- Sports, etc. betting
- ERC-20 exchange platform
