---
title: '01 - Intro to Blockchain & Smart Contracts'
description: 'The heart of modern cryptocurrency'
categories: ['lesson']
tags: ['blockchain', 'smart contract', 'hashing']
outputs: ['html', 'slides']
katex: true
---

## What is "blockchain"?

"Blockchain technology" is _the_ buzzword in the business. You probably have heard about everything but the kitchen sink being put "on the blockchain." Let's review what a blockchain actually is.

A good starting point for understanding the structure of a blockchain is comparing it to a [linked list](https://www.geeksforgeeks.org/data-structures/linked-list/), specifically a **singly-linked list**, which is probably the type of linked list with which you are most familiar.

Linked lists are composed of nodes that contain pointers to the next node in the list. In the context of cryptocurrency, a blockchain structure contains **blocks** which contain references to the _previous_ block in the chain. It's like a linked list, except instead of adding new nodes onto the end (furthest node) of the list, you add new blocks to the beginning (closest node).

A block on a blockchain represents a certain span of time, making a cryptocurrency's blockchain a living structure of sorts, in that it is always being updated with the next timespan's block. Bitcoin's blocks represent a timespan of about 10 minutes, and Ethereum's about 14 seconds. This timespan is called **block time**, and the data included in each block represents the activity that occurred during that time. This activity takes the form of a list of transactions, like:

| From    | To   | Amount |
| ------- | ---- | ------ |
| Alice   | Bob  | $10    |
| Charlie | Dana | $15    |
| ...     | ...  | ...    |

Everyone[^everyone] connected to a cryptocurrency's network maintains a complete copy of that cryptocurrency's blockchain. However, this means that whenever a change to the blockchain occurs (e.g. someone makes a transaction and wants to add it to a block), everyone needs to agree on whether that change is allowed, and once an agreement has been reached, that change needs to be distributed to everyone. Let's focus on agreement first.

[^everyone]: Well, not exactly _everyone_, but close enough

## Mining

## Notes

- Blockchain as a "pimped-out" linked list structure
- Blocks contain data representing activity that occurred during the block time
- Hash functions are one-way and generate a unique fingerprint for data
- Hash functions _useful for crypto_ are also "avalanching" (a tiny change in the input completely changes the output)
- Bitcoin uses `Hashcash` for mining, which uses $sha256 \circ sha256$ as its hash function[^btc-mining]
- Ethereum uses `hashimoto` for mining, which uses modified versions of $sha3\\_256$ and $sha3\\_512$[^eth-mining]

[^btc-mining]: https://en.bitcoin.it/wiki/Proof_of_work
[^eth-mining]: https://eth.wiki/concepts/ethash/ethash#mining
