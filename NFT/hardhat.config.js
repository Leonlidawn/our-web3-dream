require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: ".env" });
//  Quicknode as AWS EC2 for blockchain.

const QUICKNODE_HTTP_URL = process.env.QUICKNODE_HTTP_URL;
//metamask account private key, it gives acess on be half of your account
const PRIVATE_KEY = process.env.PRIVATE_KEY;

module.exports = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: QUICKNODE_HTTP_URL,
      accounts: [PRIVATE_KEY],
    },
  },
};