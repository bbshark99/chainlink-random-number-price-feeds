const HDWalletProvider = require('@truffle/hdwallet-provider')
const path = require('path')

require('dotenv').config()

const mnemonic = process.env['MNEMONIC']
const etherscan = process.env['ETHSCAN_API_KEY']
const infuraProjectId = process.env['INFURA_PROJECT_ID']

module.exports = {
  contracts_build_directory: path.join(__dirname, "abis"),
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      network_id: "*",
      gas: 5000000
    },
    rinkeby: {
      provider: () =>
      new HDWalletProvider(
        mnemonic,
        `wss://rinkeby.infura.io/ws/v3/${infuraProjectId}`
      ),
      network_id: 4,
      skipDryRun: true,
    }
  },
  compilers: {
    solc: {
      version: '^0.8.0',
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  plugins: [
    'truffle-plugin-verify'
  ],
  api_keys: {
    etherscan
  }
}
