## Intro to Blockchain & Smart Contracts

The heart of modern cryptocurrency

---

### "Blockchain Technology"

---

Remember linked lists?

```java [2]
class LinkedListNode {
  public LinkedListNode nextNode; // Singly-linked
  public Object data;
}
```

---

Blocks reference _previous_ blocks

```java [3]
class Block {
  public BlockId id;
  public BlockId previousBlockId;
  public Object data;
  // Other nifty stuff...
}
```

---

Linked List:

```txt
First Node -> Node -> Node -> Last Node
```

Blockchain:

```txt
Newest Block -> Block -> Block -> Oldest Block
```

---

**block time**

Blocks represent activity in a span of time

```txt
...
Block #34 { start: 3pm, end: 4pm, data: ... }
Block #35 { start: 4pm, end: 5pm, data: ... }
Block #36 { start: 6pm, end: 7pm, data: ... }
...
```

---

**block time** - the duration between one block and the next block

---

Cryptocurrencies store transactions in blocks

| From    | To   | Amount |
| ------- | ---- | ------ |
| Alice   | Bob  | $10    |
| Charlie | Dana | $15    |

---

**shared/distributed ledger**

Everyone connected to the cryptocurrency network has a copy of the blockchain

---

**consensus**

Adding to the blockchain...

How to make sure everyone agrees?

---

### Mining

Making free money!

---

_[insert picture of virtual miner]_

---

How to ensure agreement among nodes?

What could a node do if there were no accountability?

---

**stake** - collateral that may be forfeit if you act badly

---

**Proof-of-Stake (PoS)** - consensus algorithms that use staking of collateral to create trust

---

**Proof-of-Work (PoW)** - consensus algorithms that use computational complexity (work) to create trust

---

Miners get...

- a say in the network
- transaction fees from transactions in the block
- "free" crypto from a coinbase transaction

---

### Smart Contracts

Transactions can do more than transfer money

---

**smart contract** - code deployed on the blockchain that we can interact with using special transactions called **message calls**

---

Sending transactions

| From    | To       | Amount | Data  | Result   |
| ------- | -------- | ------ | ----- | -------- |
| Alice   | Bob      | $10    |       | Success! |
| Charlie | `sc_add` | $1     | "1+2" | 3        |

---

Lots of use-cases for smart contracts

- Auctions
- Elections
- Trading

---

They also come with a lot of limitations

- Stored on a public blockchain
- Can't get information from any one node or even the Internet
- Must be **deterministic**

---

Ethereum smart contracts use Solidity or Vyper

We will use Solidity in this course

---

That's it!
