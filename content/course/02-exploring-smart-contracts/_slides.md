## Exploring Smart Contracts

Diving into some real-life smart contracts!

---

One popular use-case: implementing another coin _on top of ETH!_

---

**token standard** - a formal contract specification of a token with certain functionality

---

Some well-known token standards

- ERC-20: Fungible tokens
- ERC-721: Non-fungible tokens
- ERC-777: Fungible Tokens 2: Electric Boogaloo
- ERC-1155: Multi tokens

---

**ERC** - Ethereum Request for Comments

---

**fungibility** - if an asset is completely interchangable with another asset, they are _fungible_

---

## ERC-20

Fungible tokens

---

Mapping from address to balance

| Address | Balance |
| ------- | ------- |
| Alice   | 40      |
| Bob     | 30      |

---

Token metadata

- Name
- Symbol
- Total supply
- Decimals

---

Sample Implementations

- [OpenZeppelin ERC-20](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol)

---

Scenario: Alice sends some ERC-20 tokens to a contract's address.

Can the contract use the tokens?

---

Does the contract _know_ whether it has tokens to use?

Does Alice know that the contract knows how to handle those tokens?

---

Solution: Allowances!

---

1. Allow an address to transfer some of your tokens.
2. Tell the contract to transfer those tokens.

---

Problems:

- Two-step process
- Possibility for failure at every step

---

Let's explore some real-life ERC-20 token contracts:

- [VSL token](https://etherscan.io/address/0xDb144CD0F15eE40AaC5602364B470d703d7e16b6#code) (dead project)
- [ENJ token](https://etherscan.io/address/0xf629cbd94d3791c9250152bd8dfbdf380e2a3b9c#code) and [security audit](https://callisto.network/enjin-token-enj-security-audit/)

(Not endorsing any of these projects.)

---

Issues

- [Allowance Double Withdrawal Attack](https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit)

---

## ERC-721

Non-fungible Tokens (NFT's)

---

Mapping token to owner address

| Token | Owner |
| ----- | ----- |
| #1    | Alice |
| #2    | Bob   |
| #3    | Alice |

---

Token metadata

- Name
- Symbol
- Total supply

---

Sample Implementations

- [OpenZeppelin ERC-721](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol)
- [0xcert nf-token](https://github.com/0xcert/ethereum-erc721/blob/master/src/contracts/tokens/nf-token.sol)

---

Allowances are still a thing, but they are given on a per-token basis

---

Real-life examples

- [This NFT from Rarible](https://etherscan.io/address/0x0a59849de1e4bd9cb9fcfe303678523fba10de33#code), [original Rarible listing](https://rarible.com/rimowa_metaverse)
- [VOXIES Token](https://etherscan.io/address/0xe3435edbf54b5126e817363900234adfee5b3cee#code)

(Not endorsing any of these projects.)

---

Issues

- [General inefficiency](https://medium.com/alphawallet/epic-fail-the-consequences-of-poor-erc-design-what-you-can-do-about-it-503e19c750)

---

## Other Interesting Contracts

---

- [DoubleOrNothing](https://etherscan.io/address/0x66d58f0a2a44742688843ceb8c0fa8d8567e3c54#code) - bet your ETH
- [H2G2](https://etherscan.io/address/0xb957d92d7feae5be6877aa94997de6dcd36b65f4#code) - technically an ERC-20 token, with a sentimental addition
- [NEXO Token](https://etherscan.io/address/0xb62132e35a6c13ee1ee0f84dc5d40bad8d815206#code) - another solution to accidentally transferred ERC-20 tokens

---

Up next: Writing smart contracts in Solidity!

---

That's all, folks!
