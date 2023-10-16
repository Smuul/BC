// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.18;

contract TokenContract {
    address public owner;
    uint256 public tokenPrice = 5 ether;
    address public whoDeposited;
    uint public depositAmount;
    uint public accountBalance;

    struct Receivers {
        string name;
        uint256 tokens;
    }
    mapping(address => Receivers) public users;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
        users[owner].tokens = 100;
    }


    function double(uint256 _value) public pure returns (uint256) {
        return _value * 2;
    }

    function tokens() public view returns (uint256) {
        return users[msg.sender].tokens;
    }

    function deposit(uint256 _tokenAmount) public payable {

    uint256 requiredEther = _tokenAmount * tokenPrice;
    require(msg.value == requiredEther, "Insufficient Ether sent");
    require(users[owner].tokens >= _tokenAmount, "Owner doesn't have enough tokens");

    users[owner].tokens = users[owner].tokens - _tokenAmount;
    users[msg.sender].tokens = users[msg.sender].tokens + _tokenAmount;
    }

    function register(string memory _name) public {
        users[msg.sender].name = _name;
    }

    function giveToken(address _receiver, uint256 _amount) public onlyOwner {
        require(users[owner].tokens >= _amount);
        users[owner].tokens -= _amount;
        users[_receiver].tokens += _amount;
    }
}