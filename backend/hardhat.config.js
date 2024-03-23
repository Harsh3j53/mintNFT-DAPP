
require("@nomicfoundation/hardhat-toolbox");

require("dotenv").config();


module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: process.env.REACT_APP_SEPOLIA_RPC_URL,
      accounts: [process.env.REACT_APP_PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: process.env.REACT_APP_ETHERSCAN_KEY,
  },
};
