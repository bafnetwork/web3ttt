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

Everyone[^everyone] connected to a cryptocurrency's network maintains a complete copy of that cryptocurrency's blockchain. However, this means that whenever a change to the blockchain occurs (e.g. someone makes a transaction and wants to add it to a block), everyone needs to agree on whether that change is allowed, and once agreement has been reached, that change can be distributed to everyone.

[^everyone]: Well, not exactly _everyone_, but close enough for now

## Mining

The idea of "mining" cryptocurrency lends itself to some imaginative mental imagery of steampunk hackers delving into the depths of cyberspace to extract mysterious cryptographic treasures. While it's a fun thought, the reality of mining is a lot more like balancing hundreds of millions of checkbooks at once than it is like chopping rocks with a digital pickaxe.

### The problem of consensus

Since anyone is allowed to connect and propose new blocks to a cryptocurrency network, there has to be some way to ensure that only legitimate blocks (i.e. those containing legitimate transactions) are added to the chain and that illegitimate blocks are rejected from the chain. However, the network is made up of a whole bunch of strangers whose only common link is that they want to use the same cryptocurrency, and thus, they have little to no reason to trust each other to make the _correct_ decision as opposed to the decision that most benefits themselves.

One way to create a trust bond between strangers is for them to offer some sort of collateral to each other. For example, Alice could offer $100 collateral to the network as proof that she will be honest, and if she _isn't_ honest, the network has permission to appropriate that money.

This simple example is roughly similar to the category of consensus algorithms known as **Proof-of-Stake (PoS)**. Nodes connected to the network will offer some of their crypto as **stake**, which will be forfeited if the node acts incorrectly.

Ethereum is switching to proof-of-stake as part of the Eth2 series of upgrades.[^eth2-pos] Until that happens, Ethereum (and Bitcoin) both operate using a type of consensus called proof-of-work.

[^eth2-pos]: https://ethereum.org/en/developers/docs/consensus-mechanisms/pos/

**Proof-of-Work (PoW)** is similar to PoS in that they both have the end goal of helping the network agree (reach consensus). However, in PoW, the "collateral" offered by a node is not in terms of crypto, but in terms of computing power. A node races against other nodes to be the first to find the solution to a math problem. If they find the solution, they get to add a block to the chain. However, if they're dishonest, they waste all of the computing power they invested into mining, which is quite a lot.[^btc-environment]

[^btc-environment]: https://www.independent.co.uk/climate-change/news/bitcoin-bad-environment-mining-cryptocurrency-b1846773.html

Regardless of the consensus algorithm used, nodes are incentivized to participate in the mining process because:
1. They get to help decide which transactions make it into the next block
2. They receive **transaction fees**
3. They receive a **block reward**

The block reward is a sum of cryptocurrency awarded to whoever successfully mines the next block on the blockchain. It comes from the block's **coinbase transaction**, which is a transaction with a fixed value that a miner is allowed to generate in a mined block.

## Smart Contracts

## Notes

- Blockchain as a "pimped-out" linked list structure
- Blocks contain data representing activity that occurred during the block time
- Hash functions are one-way and generate a unique fingerprint for data
- Hash functions _useful for crypto_ are also "avalanching" (a tiny change in the input completely changes the output)
- Bitcoin uses `Hashcash` for mining, which uses $sha256 \circ sha256$ as its hash function[^btc-mining]
- Ethereum uses `hashimoto` for mining, which uses modified versions of $sha3\\_256$ and $sha3\\_512$[^eth-mining]

[^btc-mining]: https://en.bitcoin.it/wiki/Proof_of_work
[^eth-mining]: https://eth.wiki/concepts/ethash/ethash#mining
