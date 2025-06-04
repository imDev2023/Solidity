require("@nomicfoundation/hardhat-toolbox");
const dotenv = require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "sepolia",
  networks: {
    hardhat: {
    },
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: [`${process.env.PRIVATE_KEY}`]
    }
  }
}
