---
title: '05 - Connecting to Web Apps'
description: 'Using the Ethers.js library to add web3 interactions to a web application'
categories: ['lesson']
tags: ['ethers.js', 'metamask', 'react', 'web app', 'web3 provider', 'abi']
outputs: ['html', 'slides']
katex: true
---

Reference [the sample project](https://github.com/bafnetwork/web3ttt/tree/main/examples/05) to see all of this in action.

## Working with Web3 API's in-browser

Unfortunately, most major web browsers do not yet natively provide support for Web3 API's, so access to those API's is usually provided via some sort of browser extension. In the case of Ethereum, the most popular extension that does this is [MetaMask](https://metamask.io/). Make sure that you have it installed on your browser before continuing!

MetaMask provides access to a Web3 RPC[^rpc] interface in the form of the `window.ethereum` object injected into the page. If you have the extension installed, you can open up your browser console right now and tinker with it.

[^rpc]: **R**emote **P**rocedure **C**all

Applications interface with the Web3 provider in two primary ways: RPC calls and event listeners.

### Events

If you're familiar with JavaScript's event-driven design pattern, MetaMask's events will feel right at home. Handlers are registered using `ethereum.addListener(eventName, listener)` and removed with `ethereum.removeListener(eventName, listener)`. [See the list of available events.](https://docs.metamask.io/guide/ethereum-provider.html#events)

### RPC Calls

RPC calls are performed by calling [`ethereum.request(...)`](https://docs.metamask.io/guide/ethereum-provider.html#ethereum-request-args). [See the list of available RPC methods.](https://docs.metamask.io/guide/rpc-api.html) This is how things like transactions are sent. However, the request parameters can become very complicated very quickly for all but the simplest of requests, so that's where the Ethers.js library steps in to help.

## Web App Integration

Initiating a connection with a user's MetaMask is fairly straightforward. All that we have to do is request access to the user's account, and MetaMask will prompt the user to accept or reject the request.

```js
const accounts = await window.ethereum.request({
  method: 'eth_requestAccounts',
});
```

Note that although the method name is called `eth_requestAccounts` (_plural_), at the moment MetaMask will never return more than one account at a time, that being the currently selected account. At the time of writing, MetaMask will not, for example, return a list of all the accounts the user has connected to the app.[^metamask-multiple-accounts]

[^metamask-multiple-accounts]: https://docs.metamask.io/guide/ethereum-provider.html#accountschanged

When a user connects a new account to a web app, selects a different account to use, or disconnects MetaMask from a web app, the `accountsChanged` event will fire:

```js
ethereum.addListener('accountsChanged', (accounts) => {
  // accounts is an array of addresses, length of either 0 or 1
});
```

At any time, we can request the connected accounts (without prompting the user to authorize a new account) with the following RPC call:

```js
const accounts = await ethereum.request({ method: 'eth_accounts' });
```

Using these RPC requests and event listeners, we can easily write a web app that connects to MetaMask and dynamically updates its connection status as the user authorizes or deauthorizes accounts. Take a look at the [`useConnection` React hook](https://github.com/bafnetwork/web3ttt/blob/main/examples/05/src/hooks/Connection.js) in the example project.

## Working with Ethers.js

Install Ethers.js into our Node.js project by running the following command:

```txt
$ npm install --save ethers
```

Then import it into our project:

```js
import { ethers } from 'ethers';
```

Ethers.js supports many different types of Ethereum RPC providers in many different contexts. For instance, it can connect to a JSON RPC node directly (e.g. if you were writing a server-side Node.js app), but in our case, since we're building a simple web app, we're going the simpler route of just handing it our `window.ethereum` object and telling it to go from there:

```js
const provider = new ethers.providers.Web3Provider(window.ethereum);
```

The primary reason we're using Ethers.js is to make it easier for us to interact with our smart contracts on the blockchain, so let's create a handle for our contract:

```js
const contract = new ethers.Contract(
  contractAddress,
  contractAbi,
  provider.getSigner(0), // Use the first (selected) address provided by MetaMask
);
```

The value `contractAddress` is, of course, the address at which our contract is deployed, something like `0x98C47B781Bcb1A0E3c1155822fA3199359576e9f`.

But what is `contractAbi`?

## Application Binary Interface

Ethers.js doesn't much of anything about our smart contract, so we need to tell Ethers.js how to interact with it. That's where the **application binary interface** (ABI) comes in. The ABI is a JSON description of the interface of a smart contract, and it provides enough information for Ethers.js to correctly construct transactions that interact with the contract.

We can generate an ABI for a smart contract by running the following command:

```txt
$ solc[js] --abi <path-to-contract>
```

(Compiling a contract with Truffle will also generate an ABI stored under the `abi` key in the output JSON.)

For instance:

```txt
$ solcjs --abi ./PyramidScheme.sol
```

It will generate a file that looks something like this (don't bother trying to read this, it's just to give a taste of what an ABI looks like):

```txt
[{"inputs":[{"internalType":"address payable","name":"_owner","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"CreditReceivedEvent","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"CreditWithdrawnEvent","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"recruit","type":"address"},{"indexed":true,"internalType":"address","name":"recruiter","type":"address"},{"indexed":false,"internalType":"uint256","name":"initiationFee","type":"uint256"}],"name":"SignUpEvent","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"TransferEvent","type":"event"},{"inputs":[],"name":"INITIATION_FEE","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"wallet","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"buy","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"wallet","type":"address"}],"name":"creditOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address payable","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"recruiter","type":"address"}],"name":"signUp","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"withdrawCredit","outputs":[],"stateMutability":"nonpayable","type":"function"}]
```

All we have to do is stuff that value into the `ethers.Contract` constructor and it will do all of the rest of the work for us.

## Contract Interactions

Ethers.js creates proxy methods[^meta-class] on the contract handle that can be used to fire off requests through MetaMask. Contract methods are mapped directly by name to a JavaScript property of the contract handle. That is to say, if our contract has a method called `balanceOf(address)`, we can call it from JavaScript simply by saying:

[^meta-class]: https://docs.ethers.io/v5/api/contract/contract/#Contract--metaclass

```js
contract.balanceOf(address); // => Promise<BigNumber>
```

Contract method calls return `Promise`s, so we will have to `await` the return value to see the result of the call. Additional parameters (such as attached ether, gas limit, etc.) can be specified in an optional, final, `overrides` parameter:

```js
contract.signUp(recruiterAddress, {
  value: ethers.utils.parseEther('1'), // Send 1 ETH along with transaction
});
```

## Notes

- [MetaMask API documentation](https://docs.metamask.io/)
- [Ethers.js documentation](https://docs.ethers.io/)
