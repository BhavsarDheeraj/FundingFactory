// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./FundContract.sol";

contract FundingFactory {
    FundContract[] public fundings;

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

    function retrieveFundsFor(address _fundAddress) public view returns(bool, uint256) {
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
}