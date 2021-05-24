pragma solidity ^0.8.4;

contract VeryExpensiveToken {
    mapping (address => uint256) public balances;
    uint256 public totalSupply = 0;
    // ETH can be sent to payable addresses
    address payable public owner;
    
    // Called when the contract is first deployed
    constructor (address payable _owner) {
        owner = _owner;
    }
    
    // Events appear in logs (e.g. for debugging) and web3 applications can listen for them
    // Indexed parameters are searchable in logs
    event BuyEvent(address indexed buyer, uint256 indexed tokenIndex, uint256 price);
    
    // Functions marked payable have access to msg.value, which is a quantity of
    // ETH tokens sent along with the function call
    function buy () external payable {
        uint256 _totalSupply = totalSupply;
        require(msg.value >= _nextTokenCost(_totalSupply),
            "Not enough to buy next token");
        totalSupply = _totalSupply + 1;
        balances[msg.sender]++;
        
        // Emits an event
        emit BuyEvent(msg.sender, _totalSupply, msg.value);
    }
    
    function buyOut () external payable {
        require(msg.value >= (2 ** (2 * totalSupply)) * 1 ether, "Not enough to buy out");
        address payable oldOwner = owner;
        owner = payable(msg.sender);
        (bool success,) = oldOwner.call{ value: address(this).balance }("");
        require(success, "Withdraw failed");
    }
    
    function nextTokenCost () external view returns (uint256) {
        return _nextTokenCost(totalSupply);
    }
    
    // Pure functions cannot modify state, like view functions, but it also
    // cannot read state either
    function _nextTokenCost (uint256 _totalSupply) public pure returns (uint256) {
        // There are some nice keywords for pecuniary numbers in Solidity:
        //   1 wei == 1
        //   1 gwei == 1e9
        //   1 ether == 1e18
        // Also for durations:
        //   1 seconds == 1
        //   minutes, hours, days, weeks
        return (2 ** _totalSupply) * 1 ether;
    }
    
    function withdraw () public {
        assert(msg.sender == owner);

        // Although .send() and .transfer() functions exist for sending ETH,
        // their use is no longer recommended because they rely on a constant
        // gas cost for computations which is no longer a safe assumption
        // https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now
        // !!!WARNING!!!
        // There is potential for even worse bugs or vulnerabilities if this
        // method is not used carefully. Proper usage is covered in the next
        // section.
        (bool success,) = owner.call{ value: address(this).balance }("");
        require(success, "Withdraw failed");
    }
    
    function balanceOf (address _wallet) external view returns (uint256) {
        return balances[_wallet];
    }
    
    function transfer (address _to, uint256 _amount) public {
        // ...
    }
}
