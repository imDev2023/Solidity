// > JS script.js >> main
// but useful for running the script in a standalone fashion through
//
// When running the script with `npx hardhat run <script>` you'll fi
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
async function main() {
// Hardhat always runs the compile task when running scripts with
// line interface.
//
// If this script is run directly using `node` you may want to cal
// manually to make sure everything is compiled
// await hre.run('compile');
// We get the contract to deploy
const Web3Builder = await hre.ethers.getContractFactory("Web3Builder")
const web3Builder = await Web3Builder.deploy("Hello, Hardhat!");
await web3Builder.deployed();
I
console.log("Crypto Coin destroyed deployed to:", web3Builder.address);
// We recommend this pattern to be able to use async/awaite
// and properly handle errors.
main()
.then(() => process.exit(0))
.catch((error) => {
console.error(error);
process.exit(1);
});
}