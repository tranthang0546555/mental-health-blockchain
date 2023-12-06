import hre from "hardhat";

async function main() {
  const MedicalRecord = await hre.ethers.getContractFactory("MedicalRecord");
  const contract = await hre.upgrades.deployProxy(MedicalRecord);
  await contract.waitForDeployment()
  console.log("MedicalRecord proxy deployed to: ", await contract.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
