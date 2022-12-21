import { ethers } from "hardhat";

async function main() {
  console.log('trying to deploy')
  const contract = await (await ethers.getContractFactory("Whitelist")).deploy(10)
  
  console.log('deployed, need confirmation')
  //deploying a contract takes 3 steps: get Factory, send a broadcast, and then wait for block to be mined
  const deployedWhitelistContract = await contract.deployed()

  console.log(`Whitelist contract address:`, deployedWhitelistContract.address);
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });