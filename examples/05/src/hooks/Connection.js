import { useEffect, useState } from 'react';

export default function useConnection() {
  const [isConnected, setIsConnected] = useState(false);
  const [address, setAddress] = useState(null);

  // Update state variables from list of accounts
  const handler = (accounts) => {
    const connected = accounts && accounts.length > 0;
    setIsConnected(connected);
    if (connected) {
      setAddress(accounts[0]);
    } else {
      setAddress(null);
    }
  };

  // Initialize state variables
  window.ethereum
    .request({
      method: 'eth_accounts',
    })
    .then(handler);

  // Event listener for when a user logs in/out or switches accounts
  useEffect(() => {
    window.ethereum.addListener('accountsChanged', handler);

    return () => {
      window.ethereum.removeListener('accountsChanged', handler);
    };
  }, []);

  return { isConnected, address };
}
