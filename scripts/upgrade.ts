import hre from "hardhat";
require("dotenv").config();

async function main() {
    const Contract = await hre.ethers.getContractFactory("MedicalRecord")
    const existingAddress = process.env.CONTRACT_ADDRESS!;
    const contract = await hre.upgrades.upgradeProxy(
        existingAddress,
        Contract
      );
    await contract.waitForDeployment()
    console.log(`Deployed to ${await contract.getAddress()}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
