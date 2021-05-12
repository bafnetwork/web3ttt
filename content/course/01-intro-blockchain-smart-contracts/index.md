---
title: '01 - Intro to Blockchain & Smart Contracts'
description: 'The heart of modern cryptocurrency'
categories: ['lesson']
tags: ['blockchain', 'smart contract', 'hashing']
outputs: ['html', 'remark']
katex: true
---

## What is "Blockchain"

## Notes

- Blockchain as a "pimped-out" linked list structure
- Hash functions are one-way and generate a unique fingerprint for data
- Hash functions _useful for crypto_ are also "avalanching" (a tiny change in the input completely changes the output)
- Bitcoin uses `Hashcash` for mining, which uses $sha256 \circ sha256$ as its hash function[^btc-mining]
- Ethereum uses `hashimoto` for mining, which uses modified versions of $sha3\\_256$ and $sha3\\_512$[^eth-mining]

[^btc-mining]: https://en.bitcoin.it/wiki/Proof_of_work
[^eth-mining]: https://eth.wiki/concepts/ethash/ethash#mining
