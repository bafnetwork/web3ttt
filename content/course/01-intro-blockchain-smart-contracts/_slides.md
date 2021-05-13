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

Blocks reference *previous* blocks

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

--

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

## Mining

Making free money!
