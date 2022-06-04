// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./FundContract.sol";

contract FundingFactory {
    FundContract[] fundings;

    function startRaising(string memory _fundingName, uint256 _minUSD) public returns(address) {
        require(_minUSD > 0, "Min USD value should be greater than 0"); 
        FundContract funding = new FundContract({ _name: _fundingName, _minUSD: _minUSD });
        fundings.push(funding);
        return address(funding);
    }

    function addFundsTo(address _fundAddress) public returns(bool) {
        for (uint256 i = 0; i < fundings.length; i++) {
            if (address(fundings[i]) == _fundAddress) {
                fundings[i].fund();
                return true;
            }
        }
        return false;
    }

    function fundRaisedForFundingWithAddress(address _fundAddress) public view returns(bool, uint256) {
        for (uint256 i = 0; i < fundings.length; i++) {
            if (address(fundings[i]) == _fundAddress) {
                return (true, address(fundings[i]).balance);
            }
        }
        return (false, 0);
    }

    function withdrawFundsFrom(address _fundAddress) public {
        for (uint256 i = 0; i < fundings.length; i++) {
            if (address(fundings[i]) == _fundAddress) {
                fundings[i].withdraw();
                break;
            }
        }
    }

    function fundingsCount() public view returns(uint256) {
        return fundings.length;
    }

    function totalFundingsRaisedSoFar() public view returns(uint256) {
        uint256 totalRaised = 0;
        for (uint256 i = 0; i < fundings.length; i++) {
            totalRaised += address(fundings[i]).balance;
        }
        return totalRaised;
    }
}