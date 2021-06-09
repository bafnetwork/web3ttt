## Connecting to Web Apps

Using MetaMask & Ethers.js in web apps

---

Adding Web3 functionality to regular web browsers

<img src="./metamask-fox.svg" width="300" alt="MetaMask fox icon" />

---

### MetaMask

- Browser extension
- Web3 provider
- RPC interface through injected `ethereum` object

---

We will interact with MetaMask in two ways:

- Sending RPC requests via `.request(...)`
- Listening for events via `.addListener(...)`

(Also feeding it to Ethers.js)

---

Prompt the user to connect MetaMask to the web app

```js
const accounts = await window.ethereum.request({
  method: 'eth_requestAccounts',
});
```

---

Check which accounts the user currently allows the web app to access

```js
const accounts = await ethereum.request({ method: 'eth_accounts' });
```

---

Event whenever accounts are changed (authorized, deauthorized, connected, switched)

```js
ethereum.addListener('accountsChanged', (accounts) => {
  // ...
});
```

---

Check out the `useConnection` React hook in the example project that puts these to use

---

### Ethers.js

- Wrapper around web3 provider
- Feed it an application binary interface (ABI)
- Nice interface for smart contracts

---

Install

```txt
$ npm install --save ethers
```

Import

```js
import { ethers } from 'ethers';
```

---

Connect to MetaMask

```js
const provider = new ethers.providers.Web3Provider(window.ethereum);
```

---

Create a contract handle

```js
const contract = new ethers.Contract(
  contractAddress,
  contractAbi,
  provider.getSigner(0),
);
```

---

### Application Binary Interface

or "ABI" for short

---

**ABI**

Description Ethers.js (or similar library) can read and know how to interact with a contract

JSON data format

---

Generate an ABI for a contract

```txt
$ solc --abi <path-to-contract>
```

or

```txt
$ solcjs --abi <path-to-contract>
```

For example:

```txt
$ solcjs --abi ./PyramidScheme.sol
```

---

Feed the `ethers.Contract` constructor the ABI

Ethers generates proxies for each method

---

Calling a view method

```js
contract.balanceOf(address);
```

Returns `Promise<BigNumber>`

---

`Promise` - asynchronous pending result

`BigNumber` - EVM deals with numbers larger than JS's built-in `Number` type can precisely handle

---

Transactions (with optional attached ETH)

```js
contract.signUp(recruiterAddress, {
  // final `overrides` parameter
  value: ethers.utils.parseEther('1'),
});
```

---

Go forth and build dApps!
