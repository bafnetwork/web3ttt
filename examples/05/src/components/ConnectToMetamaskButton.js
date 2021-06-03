import styles from './ConnectToMetamaskButton.module.css';

export default function ConnectToMetamaskButton() {
  // Open MetaMask confirmation popup
  const connectToMetamask = async () => {
    await window.ethereum.request({ method: 'eth_requestAccounts' });
  };

  return (
    <button type="button" className={styles['connect-button']} onClick={connectToMetamask}>
      Connect to MetaMask
    </button>
  );
}
