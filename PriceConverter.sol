// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    // get 1 eth price in usd
    function getPriceInUSD() internal view returns(uint256) {
        // Rinkeby
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int price,,,) = priceFeed.latestRoundData();
        // will get price with 8 extra zeros
        return uint256(price * 1e10);
    }

    // get x amount of eth in usd
    function getConversion(uint256 ethAmount) internal view returns(uint256) {
        uint256 priceInUSD = getPriceInUSD();
        uint256 amount = (priceInUSD * ethAmount) / 1e18;
        return amount;
    }
}