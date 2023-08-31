const { ethers } = require("hardhat");
const fs = require("fs");
require("hardhat-deploy");
require("hardhat-deploy-ethers");
const utils = ethers.utils;

// comandline: npx hardhat run scripts/deploy.js --network sepolia
// comandline: npx hardhat verify --network sepolia

const nftFilePath = "./deployment/BaseXNFT.json";
const baseXNFTLibraryFilePath = "./deployment/BaseXNFTLibrary.json";
const basicNFTFilePath = "./deployment/BasicNFT.json";
require("dotenv").config();

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  const balanceBefore = await deployer.getBalance();
  console.log(
    "Account balance before deployment:",
    utils.formatEther(balanceBefore)
  );

  // // deploy BaseXLibrary
  // const BaseXNFTLibrary = await ethers.getContractFactory("BaseXNFTLibrary");
  // const baseXNFTLibrary = await BaseXNFTLibrary.deploy();
  // await baseXNFTLibrary.deployed();
  // nftData = {
  //   BaseXNFTLibraryAddress: baseXNFTLibrary.address,
  // };
  // nftJsonData = JSON.stringify(nftData, null, 2);
  // fs.writeFileSync(baseXNFTLibraryFilePath, nftJsonData);
  // console.log("baseXNFTLibrary address: ", baseXNFTLibrary.address);

  // // deploy NFT
  // const basicNFT = await ethers.getContractFactory("BasicNFT");
  // const nft = await basicNFT.deploy();
  // await nft.deployed();
  // nftData = {
  //   BasicNFTAddress: nft.address,
  // };
  // nftJsonData = JSON.stringify(nftData, null, 2);
  // fs.writeFileSync(basicNFTFilePath, nftJsonData);
  // console.log("basicNFT address: ", nft.address);

  // // delay 30s
  // await new Promise((resolve) => setTimeout(resolve, 30000));

  // deploy NFT
  const NFT = await ethers.getContractFactory("BaseXNFT", {
    libraries: {
      BaseXNFTLibrary: "0x284957863cb2C54EEDc8251C42a6b8E2303f0BDc",
    },
  });
  const nftMain = await NFT.deploy(
    "0xf30607e0cdEc7188d50d2bb384073bF1D5b02fA4",
    "0xFc49A16b26607cC32c96BCc1Ab99635ff39bEf81",
    {
      gasLimit: 10000000,
    }
  );
  await nftMain.deployed();
  console.log("baseXNFT address: ", nftMain.address);

  nftData = {
    BaseXNFTAddress: nftMain.address,
  };
  nftJsonData = JSON.stringify(nftData, null, 2);
  fs.writeFileSync(nftFilePath, nftJsonData);

  console.log("Deployment completed. Data saved to respective JSON files.");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
