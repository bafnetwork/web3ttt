import { ethers } from 'ethers';
import { useEffect, useState } from 'react';
import './App.css';
import CallViewMethodButton from './components/CallViewMethodButton';
import ConnectToMetamaskButton from './components/ConnectToMetamaskButton';
// Update contract.abi.json to contain your contract's ABI
import contractAbi from './contract.abi.json';
import useConnection from './hooks/Connection';

// Modify this to be your contract's address
const contractAddress = '0x98C47B781Bcb1A0E3c1155822fA3199359576e9f';

const provider = new ethers.providers.Web3Provider(window.ethereum);
const contract = new ethers.Contract(
  contractAddress,
  contractAbi,
  provider.getSigner(0),
);

function App() {
  // Custom React hook that listens to MetaMask events
  // Check it out in ./hooks/Connection.js
  const { isConnected, address } = useConnection();

  // A few state variables just to demonstrate different functionality of the ethers.js library
  const [owner, setOwner] = useState('');
  const [balance, setBalance] = useState('');
  const [eventCount, setEventCount] = useState(0);

  const incrementEventCount = () => {
    setEventCount((c) => c + 1);
  };

  useEffect(() => {
    if (isConnected) {
      setEventCount(0);

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
        // Only detects events where the current user withdraws credit
        console.log('CreditWithdrawnEvent with filter', args);
        incrementEventCount();
      });

      return () => {
        contract.removeAllListeners();
      };
    }
  }, [isConnected, address]);

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
      // This promise will reject if the user cancels the transaction
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
          <CallViewMethodButton
            name="Balance"
            onUpdate={getBalance}
            value={balance}
          />
          <CallViewMethodButton
            name="Owner"
            onUpdate={getOwner}
            value={owner}
          />
          <button type="button" onClick={buy}>
            Buy
          </button>
          <p>Credit Withdrawn Events: {eventCount}</p>
        </>
      ) : (
        <ConnectToMetamaskButton />
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
