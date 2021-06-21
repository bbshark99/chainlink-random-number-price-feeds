require('dotenv').config()

var PriceFeeds = artifacts.require('PriceFeeds')

var CHAINLINK_VRF_COORDINATOR = process.env.CHAINLINK_VRF_COORDINATOR
var CHAINLINK_LINK_TOKEN = process.env.CHAINLINK_LINK_TOKEN
var CHAINLINK_KEY_HASH = process.env.CHAINLINK_KEY_HASH

var BTC_USDT = process.env.BTC_USDT;
var ETH_USDT = process.env.ETH_USDT;
var BNB_USDT = process.env.BNB_USDT;

module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(PriceFeeds, CHAINLINK_VRF_COORDINATOR, CHAINLINK_LINK_TOKEN, CHAINLINK_KEY_HASH)

  const priceFeed = await PriceFeeds.deployed()
  await priceFeed.initialize(BTC_USDT, ETH_USDT, BNB_USDT)
}
