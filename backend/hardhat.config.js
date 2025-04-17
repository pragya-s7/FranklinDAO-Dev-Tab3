require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const PRIVATE_KEY = process.env.PRIVATE_KEY;

module.exports = {
  solidity: "0.8.19",
  networks: {
    zetachain_testnet: {
      url: "https://rpc.ankr.com/zetachain_evm_athens",
      chainId: 7001,
      accounts: [PRIVATE_KEY],
    },
    // You can add more EVM chains here
  },
};
