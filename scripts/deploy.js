const { ethers, network } = require("hardhat")
const fs = require("fs")


require("dotenv").config();

VOTING_INSTANCE_ADRESSES = "../constants/VotingInstanceAddresses.json"
VOTING_MANAGER_ADDRESS = "./constants/VotingManagerAddress.json"
// VOTING_MANAGER_ADDRESS = "./VotingManagerAddress.json"

async function main() {
  
  
  



  const VotingManagerFactory = await ethers.getContractFactory("VotingManager")
  console.log("Deploying contract...")
  const votingManager = await VotingManagerFactory.deploy() 
  await votingManager.waitForDeployment() 
  console.log("Deployed contract to:", await votingManager.getAddress())
  await addCurrentContractAddress(votingManager)



}



async function addCurrentContractAddress(votingInstance) {
  try {
      const { deployer } = await getNamedAccounts();
      // const votingInstance = await ethers.getContractAt("Voting", deployer);
      const chainId = network.config.chainId.toString();
      const currentVotingAddress = JSON.parse(fs.readFileSync(VOTING_MANAGER_ADDRESS, "utf8"));

      // Ensure that the array for the current chainId exists
    //   if (!currentVotingAddress[chainId]) {
    //       // Initialize it as an empty array
    //       currentVotingAddress[chainId] = [];
    //   }
    //   if(chainId in currentVotingAddress){
    //       if(!currentVotingAddress[chainId].includes(await votingInstance.getAddress())){
    //           // currentVotingAddress[chainId].push(await votingInstance.getAddress());
    //           currentVotingAddress[chainId] = await votingInstance.getAddress();
    //       }
    //   }
      currentVotingAddress["chainId"] = chainId;
      currentVotingAddress["address"] = await votingInstance.getAddress();
      // Push the new voting instance address into the array
      // currentVotingAddress[chainId].push(await votingInstance.getAddress());

      // Write the updated JSON back to the file
      fs.writeFileSync(VOTING_MANAGER_ADDRESS, JSON.stringify(currentVotingAddress));
  } catch (error) {
      console.error("Error updating front end:", error);
  }
}



main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })