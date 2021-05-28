// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

contract PyramidScheme {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public credit;
    mapping(address => address) public parents;
    uint256 public totalSupply = 0;
    address payable public owner;
    uint256 constant initiationFee = 1 ether;

    constructor(address payable _owner) {
        owner = _owner;
        parents[owner] = owner;
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
        require(msg.value >= initiationFee, "Insufficient initiation fee");
        require(msg.sender != owner, "Owner cannot sign up");

        parents[msg.sender] = recruiter;
        distributeFee(recruiter, msg.value);
        balances[msg.sender] += msg.value;
    }

    function distributeFee(address recruiter, uint256 value) internal {
        if (value == 0) {
            return;
        }

        if (recruiter == owner) {
            credit[recruiter] += value;
        } else {
            uint256 reward = value / 2;
            credit[recruiter] += reward;
            distributeFee(parents[recruiter], value - reward);
        }
    }

    function balanceOf(address _wallet) public view returns (uint256) {
        return balances[_wallet];
    }

    function withdrawCredit() public {
        require(credit[msg.sender] != 0, "No credit to withdraw");
        uint256 value = credit[msg.sender];
        credit[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: value}("");
        require(success, "Withdraw failed");
    }

    function transfer(address _to, uint256 _amount) public {
        require(_amount > 0, "Amount must be nonzero");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
