pragma solidity ^0.8.4;

contract InconspicuousToken {
    mapping (address => uint256) balances;
    uint256 public totalSupply = 0;
    // Constant values are defined at compile time and replaced throughout the
    // contract so they do not incur a storage read cost.
    uint256 constant minimumBuy = 1 gwei;
    
    function balanceOf (address _wallet) external view returns (uint256) {
        return balances[_wallet];
    }
    
    // Errors look a little bit like events, but they halt execution when used
    error InsufficientBuy();
    
    // Custom function modifiers alter function behavior
    modifier enforceMinimumBuy () {
        // Similar to a require(...) call
        if (msg.value < minimumBuy) {
            revert InsufficientBuy();
        }
        
        // Will be replaced with the modified function's body
        _;
    }
    
    function contractBalance () external view returns (uint256) {
        return address(this).balance;
    }
    
    // Uses a custom function modifier to ensure that a condition is met
    function buy () payable external enforceMinimumBuy {
        balances[msg.sender] += msg.value;
        totalSupply += msg.value;
    }
    
    function sell () external {
        // !!!WARNING!!!
        // This function is vulnerable!
        
        // Send the user their unwrapped funds
        uint256 balance = balances[msg.sender];
        (bool success,) = payable(msg.sender).call{
            value: balance
        }("");
        
        // Don't empty their wallet if the transaction failed
        if (success) {
            totalSupply -= balance;
            balances[msg.sender] = 0;
        }
    }
    
    function transfer (address _to, uint256 _amount) external {
        // ...
    }
}
