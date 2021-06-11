// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

contract PyramidScheme {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public credit;
    mapping(address => address) public parents;
    uint256 public totalSupply = 0;
    address payable public immutable owner;
    uint256 public constant INITIATION_FEE = 1 ether;

    event SignUpEvent(
        address indexed recruit,
        address indexed recruiter,
        uint256 initiationFee
    );
    event CreditReceivedEvent(address indexed to, uint256 amount);
    event CreditWithdrawnEvent(address indexed from, uint256 amount);
    event TransferEvent(
        address indexed from,
        address indexed to,
        uint256 value
    );

    constructor(address payable _owner) {
        owner = _owner;
        parents[_owner] = _owner;
    }

    function buy() external payable {
        require(msg.sender != owner, "Owner cannot buy more");
        require(parents[msg.sender] != address(0x0), "Must sign up first");

        balances[msg.sender] += msg.value;
        distributeFee(parents[msg.sender], msg.value);
    }

    function signUp(address recruiter) external payable {
        require(parents[msg.sender] == address(0x0), "Already signed up");
        require(parents[recruiter] != address(0x0), "Unknown recruiter");
        require(msg.value >= INITIATION_FEE, "Insufficient initiation fee");
        require(msg.sender != owner, "Owner cannot sign up");

        parents[msg.sender] = recruiter;
        distributeFee(recruiter, msg.value);
        balances[msg.sender] += msg.value;

        emit SignUpEvent(msg.sender, recruiter, msg.value);
    }

    function distributeFee(address recruiter, uint256 value) internal {
        if (value == 0) {
            return;
        }

        if (recruiter == owner) {
            credit[recruiter] += value;

            emit CreditReceivedEvent(recruiter, value);
        } else {
            uint256 reward = (value - 1) / 2 + 1; // Round up
            credit[recruiter] += reward;
            distributeFee(parents[recruiter], value - reward);

            emit CreditReceivedEvent(recruiter, reward);
        }
    }

    function balanceOf(address wallet) external view returns (uint256) {
        return balances[wallet];
    }

    function withdrawCredit(uint256 amount) external {
        require(amount != 0, "Amount cannot be zero");

        uint256 currentCredit = credit[msg.sender];
        require(currentCredit != 0, "No credit to withdraw");
        require(amount <= currentCredit, "Insufficient credit");

        credit[msg.sender] = currentCredit - amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdraw failed");

        emit CreditWithdrawnEvent(msg.sender, amount);
    }

    function creditOf(address wallet) external view returns (uint256) {
        return credit[wallet];
    }

    function transfer(address to, uint256 amount) external {
        require(amount > 0, "Amount must be nonzero");
        uint256 balance = balances[msg.sender];
        require(balance >= amount, "Insufficient balance");

        balances[msg.sender] = balance - amount;
        balances[to] += amount;

        emit TransferEvent(msg.sender, to, amount);
    }
}
