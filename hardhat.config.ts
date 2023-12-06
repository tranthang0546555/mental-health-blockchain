import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";
import "@nomicfoundation/hardhat-ethers";
import "@openzeppelin/hardhat-upgrades";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.19",
  },
  defaultNetwork: "goerli",
  networks: {
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/3A1U37nBBzAZqDIeZlFznXQOxYhpMFo0",
      accounts: [
        "b52154fbf5a561567431f004923a599bfde4dfb1490f8d5d9309e982156845d0",
      ],
    },
  },
};

export default config;
