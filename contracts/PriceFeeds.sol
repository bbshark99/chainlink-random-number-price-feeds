// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/dev/VRFConsumerBase.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract PriceFeeds is VRFConsumerBase, Ownable {
    enum Currency {BTC_USDT, ETH_USDT, BNB_USDT}
    // Chainlink Coordinator values
    bytes32 private keyHash_;
    uint256 private fee_;

    // Chainlink Feed Contract Address => AggregatorInterface
    mapping(address => AggregatorV3Interface) private priceFeeds_;
    // Currencies => Price Feed Contract Address
    mapping(Currency => address) private currencyFeeds_;
    // Random Number generated
    event NewRandomNumber(uint256 value);

    constructor(
        address _vrfCoordinator,
        address _linkToken,
        bytes32 _keyHash
    ) VRFConsumerBase(_vrfCoordinator, _linkToken) {
        keyHash_ = _keyHash;
        fee_ = 0.1 * (10**18);

        // Main Net
        priceFeeds_[
            0x14e613AC84a31f709eadbdF89C6CC390fDc9540A
        ] = AggregatorV3Interface(0x14e613AC84a31f709eadbdF89C6CC390fDc9540A);
        priceFeeds_[
            0x14e613AC84a31f709eadbdF89C6CC390fDc9540A
        ] = AggregatorV3Interface(0x14e613AC84a31f709eadbdF89C6CC390fDc9540A);
        priceFeeds_[
            0x14e613AC84a31f709eadbdF89C6CC390fDc9540A
        ] = AggregatorV3Interface(0x14e613AC84a31f709eadbdF89C6CC390fDc9540A);

        // Rinkeby Net
        priceFeeds_[
            0xcf0f51ca2cDAecb464eeE4227f5295F2384F84ED
        ] = AggregatorV3Interface(0xcf0f51ca2cDAecb464eeE4227f5295F2384F84ED);
        priceFeeds_[
            0xECe365B379E1dD183B20fc5f022230C044d51404
        ] = AggregatorV3Interface(0xECe365B379E1dD183B20fc5f022230C044d51404);
        priceFeeds_[
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        ] = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);

        // Kovan Net
        priceFeeds_[
            0x8993ED705cdf5e84D0a3B754b5Ee0e1783fcdF16
        ] = AggregatorV3Interface(0x8993ED705cdf5e84D0a3B754b5Ee0e1783fcdF16);
        priceFeeds_[
            0x6135b13325bfC4B00278B4abC5e20bbce2D6580e
        ] = AggregatorV3Interface(0x6135b13325bfC4B00278B4abC5e20bbce2D6580e);
        priceFeeds_[
            0x9326BFA02ADD2366b30bacB125260Af641031331
        ] = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);

        // BSC Main NET
        priceFeeds_[
            0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE
        ] = AggregatorV3Interface(0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE);
        priceFeeds_[
            0x264990fbd0A4796A3E3d8E37C4d5F87a3aCa5Ebf
        ] = AggregatorV3Interface(0x264990fbd0A4796A3E3d8E37C4d5F87a3aCa5Ebf);
        priceFeeds_[
            0x63D407F32Aa72E63C7209ce1c2F5dA40b3AaE726
        ] = AggregatorV3Interface(0x63D407F32Aa72E63C7209ce1c2F5dA40b3AaE726);

        // BSC TEST NET
        priceFeeds_[
            0x2514895c72f50D8bd4B4F9b1110F0D6bD2c97526
        ] = AggregatorV3Interface(0x2514895c72f50D8bd4B4F9b1110F0D6bD2c97526);
        priceFeeds_[
            0x5741306c21795FdCBb9b265Ea0255F499DFe515C
        ] = AggregatorV3Interface(0x5741306c21795FdCBb9b265Ea0255F499DFe515C);
        priceFeeds_[
            0x143db3CEEfbdfe5631aDD3E50f7614B6ba708BA7
        ] = AggregatorV3Interface(0x143db3CEEfbdfe5631aDD3E50f7614B6ba708BA7);
    }

    function initialize(
        address _btc,
        address _eth,
        address _bnb
    ) public onlyOwner {
        currencyFeeds_[Currency.BTC_USDT] = _btc;
        currencyFeeds_[Currency.ETH_USDT] = _eth;
        currencyFeeds_[Currency.BNB_USDT] = _bnb;
    }

    function getLatestPrice(address _address) public view returns (int256) {
        (, int256 price, , , ) = priceFeeds_[_address].latestRoundData();
        return price;
    }

    function getBTCLatestPrice() public view returns (int256) {
        return getLatestPrice(currencyFeeds_[Currency.BTC_USDT]);
    }

    function getETHLatestPrice() public view returns (int256) {
        return getLatestPrice(currencyFeeds_[Currency.ETH_USDT]);
    }

    function getBNBLatestPrice() public view returns (int256) {
        return getLatestPrice(currencyFeeds_[Currency.BNB_USDT]);
    }

    function generateRandomNumber(uint256 _seed) public {
        require(keyHash_ != bytes32(0), "Must have valid key hash");
        require(
            LINK.balanceOf(address(this)) >= fee_,
            "Not enough LINK - fill contract with faucet"
        );

        requestRandomness(keyHash_, fee_, _seed);
    }

    function fulfillRandomness(bytes32, uint256 randomness) internal override {
        emit NewRandomNumber(randomness);
    }
}
