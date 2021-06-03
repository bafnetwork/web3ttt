import * as styles from './App.module.css';
import { ethers } from 'ethers';
import { useState, useEffect } from 'react';

// Update contract.abi.json to contain your contract's ABI
import contractAbi from './contract.abi.json';

// Modify this to be your contract's address
const contractAddress = '0x98C47B781Bcb1A0E3c1155822fA3199359576e9f';

const provider = new ethers.providers.Web3Provider(window.ethereum);
const contract = new ethers.Contract(
  contractAddress,
  contractAbi,
  provider.getSigner(0),
);

function App() {
  // A few state variables just to demonstrate different functionality of the ethers.js library
  const [address, setAddress] = useState('');
  const [owner, setOwner] = useState('');
  const [balance, setBalance] = useState('');
  const [numWithdrawEvents, setNumWithdrawEvents] = useState(0);

  const isConnected = !!address;

  const incrementCwEvents = () => {
    setNumWithdrawEvents((c) => c + 1);
  };

  const init = () => {
    // Initialize address
    provider
      .getSigner(0)
      .getAddress()
      .then(async (address) => {
        setAddress(address);

        // MetaMask event listener for when the user switches accounts
        // There should be more logic in here, but for now we'll just leave it
        window.ethereum.addListener('accountsChanged', (accounts) => {
          setAddress(accounts[0]);
          // Should probably update event filters, etc...
        });

        // You can subscribe to contract events by specifying the name of the
        // event, and then this callback will be executed every time such an
        // event occurs
        contract.on('SignUpEvent', (recruit, recruiter, initiationFee) => {
          console.log('SignUpEvent', recruit, recruiter, initiationFee);
        });

        // You can also access filters generated from the ABI.
        // Passing arguments to the filter generator will filter the events by
        // indexed argument.
        // Recall that the signature of this event is:
        // > event CreditWithdrawnEvent(address indexed from, uint256 amount);
        contract.on(contract.filters.CreditWithdrawnEvent(address), (...args) => {
          console.log(
            'CreditWithdrawnEvent with filter',
            args,
            numWithdrawEvents,
          );
          incrementCwEvents();
        });
      });
  };

  useEffect(() => {
    if (isConnected) {
      init();
    }
  }, []);

  // Open MetaMask confirmation popup
  const connectToProvider = async () => {
    await window.ethereum.request({ method: 'eth_requestAccounts' });
    init();
  };

  // Read-only method call
  const getOwner = async () => {
    setOwner(await contract.owner());
  };

  // Read-only method call, returns a BigNumber
  const getBalance = async () => {
    setBalance((await contract.balanceOf(address)).toString());
  };

  // Write method with attached ETH
  const buy = async () => {
    const valueStr = prompt(
      'How much would you like to buy?',
      'Value in ether',
    );

    if (valueStr !== null) {
      await contract.buy({
        // Attach additional value to this transaction
        value: ethers.utils.parseEther(valueStr),
      });
      alert('Success!');
    }
  };

  return provider ? (
    <main>
      {isConnected ? (
        <>
          <p>You are connected to a web3 provider.</p>
          <p>Your current wallet address is {address}.</p>
          <table
            style={{
              width: '100%',
            }}
          >
            <tbody>
              <tr>
                <td>
                  <button type="button" onClick={getBalance}>
                    Balance
                  </button>
                </td>
                <td>{balance}</td>
              </tr>
              <tr>
                <td>
                  <button type="button" onClick={buy}>
                    Buy
                  </button>
                </td>
              </tr>
              <tr>
                <td>
                  <button type="button" onClick={getOwner}>
                    Owner
                  </button>
                </td>
                <td>{owner}</td>
              </tr>
              <tr>
                <td>Credit Withdrawn Events</td>
                <td>{numWithdrawEvents}</td>
              </tr>
            </tbody>
          </table>
        </>
      ) : (
        <button
          type="button"
          className={styles.big}
          onClick={connectToProvider}
        >
          Connect to MetaMask
        </button>
      )}
    </main>
  ) : (
    <p>
      Please install a Web3 provider like{' '}
      <a href="https://metamask.io/">MetaMask</a> to use this app.
    </p>
  );
}

export default App;
