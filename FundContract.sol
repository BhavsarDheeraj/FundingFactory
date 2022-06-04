// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

contract FundContract {
    using PriceConverter for uint256;

    constructor(string memory _name, uint256 _minUSD) {
        owner = msg.sender;
        name = _name;
        minUSD = _minUSD * 1e18;
    }

    string name;
    uint256 minUSD;
    address owner;
    address[] funders;
    mapping(address => uint256) addressAmountMap;

    function fund() public payable {
        require(msg.value.getConversion() >= minUSD, "Funding amount should be greater than or equal to 10 dollars");
        funders.push(msg.sender);
        addressAmountMap[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 i = 0; i < funders.length; i++) {
            addressAmountMap[funders[i]] = 0;
        }
        funders = new address[](0);
        (bool callSend,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSend, "Withdrawal failed.");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }
}