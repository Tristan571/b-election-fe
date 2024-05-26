require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@nomicfoundation/hardhat-verify");
require("hardhat-deploy");
require("@nomicfoundation/hardhat-ignition-ethers");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.8",
  defaultNetwork: "hardhat",
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL,
      accounts: [process.env.PRIVATE_KEY_SEPOLIA],
      chainId: 11155111,
      blockConfirmations: 6,
    },
    mumbai: {
      url: process.env.MUMBAI_RPC_URL,
      accounts: [process.env.PRIVATE_KEY_MUMBAI],
      chainId: 80001,
      blockConfirmations: 6,
    },
    polygonAmoy: {
      url: process.env.AMOY_RPC_URL,
      accounts: [process.env.PRIVATE_KEY_AMOY],
      chainId: 80002,
      blockConfirmations: 6,
    },
    localhost:
    {
      url: process.env.LOCALHOST_RPC_URL,
      accounts:[process.env.PRIVATE_KEY_LOCALHOST],
      chainId: 31337,
      blockConfirmations: 6,
    },
    ganache:
    {
      url: process.env.GANACHE_RPC_URL,
      accounts:[process.env.PRIVATE_KEY_GANACHE],
      chainId: 1337,
      blockConfirmations: 6,
    }
  },
  // etherscan: {
  //   // Your API key for Etherscan
  //   // Obtain one at https://etherscan.io/
  //   apiKey: process.env.ETHERSCAN_API_KEY,
  // },
  sourcify: {
    // Disabled by default
    // Doesn't need an API key
    enabled: true,
  },
  namedAccounts: {
    deployer: {
      default: 0, // here this will by default take the first account as deployer
      1: 0, // similarly on mainnet it will take the first account as deployer. Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
    },
  },
  paths:
  {
    artifacts:'./src/artifacts',
  },
  etherscan: {
    apiKey: {
      polygonAmoy: process.env.POLYGONSCAN_API_KEY,
    },
    customChains: [
      {
        network: "polygonAmoy",
        chainId: 80002,
        urls: {
          apiURL: "https://api-amoy.polygonscan.com/api",
          browserURL: "https://amoy.polygonscan.com"
        },
      }
    ]
  },
  solidity: "0.8.8",
};
