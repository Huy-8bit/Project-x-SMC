const { ethers } = require("hardhat");
const fs = require("fs");
require("hardhat-deploy");
require("hardhat-deploy-ethers");
const utils = ethers.utils;

// comandline: npx hardhat run scripts/deploy_NFT.js --network sepolia

const nftFilePath = "./deployment/BaseXNFT.json";
const TokenFilePath = "./deployment/BaseXToken.json";
const BaseXMarketPlaceFilePath = "./deployment/BaseXMarketPlace.json";
require("dotenv").config();

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // deploy Token
  // const Token = await ethers.getContractFactory("BaseXToken");
  // const token = await Token.deploy();
  // await token.deployed();
  // console.log("Token address:", token.address);
  // console.log("Token total supply:", (await token.totalSupply()).toString());
  // const TokenData = {
  //   BaseXTokenAddress: token.address,
  // };
  // const TokenJsonData = JSON.stringify(TokenData, null, 2);
  // fs.writeFileSync(TokenFilePath, TokenJsonData);

  // deploy NFT
  const NFT = await ethers.getContractFactory("BaseXNFT");
  const nft = await NFT.deploy();
  await nft.deployed();
  console.log("NFT address: ", nft.address);
  const nftData = {
    BaseXNFTAddress: nft.address,
  };
  const nftJsonData = JSON.stringify(nftData, null, 2);
  fs.writeFileSync(nftFilePath, nftJsonData);

  // // deploy NFTMarketplace

  // const Wibu_NFTMarketplace = await ethers.getContractFactory(
  //   "BaseXMarketPlace"
  // );
  // const BaseXMarketPlace = await Wibu_NFTMarketplace.deploy(
  //   token.address,
  //   nft.address,
  //   baseXItem.address
  // );
  // console.log("NFTAddress: ", nft.address);
  // console.log("tokenAddress: ", token.address);
  // console.log("baseXItemAddress: ", baseXItem.address);
  // await BaseXMarketPlace.deployed();
  // console.log("BaseXMarketPlace address: ", BaseXMarketPlace.address);
  // const BaseXMarketPlaceData = {
  //   BaseXMarketPlaceAddress: BaseXMarketPlace.address,
  // };
  // const BaseXMarketPlaceJsonData = JSON.stringify(BaseXMarketPlaceData, null, 2);
  // fs.writeFileSync(BaseXMarketPlaceFilePath, BaseXMarketPlaceJsonData);

  console.log("Deployment completed. Data saved to respective JSON files.");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
