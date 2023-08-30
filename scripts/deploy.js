const { ethers } = require("hardhat");
const fs = require("fs");
require("hardhat-deploy");
require("hardhat-deploy-ethers");
const utils = ethers.utils;

// comandline: npx hardhat run scripts/deploy.js --network sepolia
// comandline: npx hardhat verify --network sepolia

const nftFilePath = "./deployment/BaseXNFT.json";
// const TokenFilePath = "./deployment/BaseXToken.json";
// const BaseXMarketPlaceFilePath = "./deployment/BaseXMarketPlace.json";
require("dotenv").config();

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  const balanceBefore = await deployer.getBalance();
  console.log(
    "Account balance before deployment:",
    utils.formatEther(balanceBefore)
  );

  // const gasLimits = utils.parseUnits("2", "ether");
  // console.log("Gas limit:", gasLimits.toString());

  const basicNFT = await ethers.getContractFactory("BasicNFT");
  const nft = await basicNFT.deploy();
  await nft.deployed();
  console.log("NFT address: ", nft.address);

  const BaseXNFTLibrary = await ethers.getContractFactory("BaseXNFTLibrary");
  const baseXNFTLibrary = await BaseXNFTLibrary.deploy();
  await baseXNFTLibrary.deployed();
  console.log("baseXNFTLibrary address: ", baseXNFTLibrary.address);

  // delay 30s
  await new Promise((resolve) => setTimeout(resolve, 30000));

  // deploy NFT
  const NFT = await ethers.getContractFactory("BaseXNFT", {
    libraries: {
      BaseXNFTLibrary: baseXNFTLibrary.address,
    },
  });

  const nftMain = await NFT.deploy(
    "0xf30607e0cdEc7188d50d2bb384073bF1D5b02fA4",
    nft.address
  );
  await nft.deployed();
  console.log("NFT address: ", nftMain.address);

  const nftData = {
    BaseXNFTAddress: nftMain.address,
  };
  const nftJsonData = JSON.stringify(nftData, null, 2);
  fs.writeFileSync(nftFilePath, nftJsonData);

  console.log("Deployment completed. Data saved to respective JSON files.");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
