const { ethers } = require("hardhat");
const fs = require("fs");
require("hardhat-deploy");
require("hardhat-deploy-ethers");
const utils = ethers.utils;

// comandline: npx hardhat run scripts/deploy_NFT.js --network sepolia

const nftFilePath = "./deployment/HeroNFT.json";
const TokenFilePath = "./deployment/HeroToken.json";
const HeroMarketPlaceFilePath = "./deployment/HeroMarketPlace.json";
const HeroItemFilePath = "./deployment/HeroItem.json";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // deploy Token
  const Token = await ethers.getContractFactory("HeroToken");
  const token = await Token.deploy();
  await token.deployed();
  console.log("Token address:", token.address);
  console.log("Token total supply:", (await token.totalSupply()).toString());
  const TokenData = {
    HeroTokenAddress: token.address,
  };
  const TokenJsonData = JSON.stringify(TokenData, null, 2);
  fs.writeFileSync(TokenFilePath, TokenJsonData);

  // deploy NFT
  const NFT = await ethers.getContractFactory("HeroNFT");
  const nft = await NFT.deploy();
  await nft.deployed();
  console.log("NFT address: ", nft.address);
  const nftData = {
    HeroNFTAddress: nft.address,
  };
  const nftJsonData = JSON.stringify(nftData, null, 2);
  fs.writeFileSync(nftFilePath, nftJsonData);

  // deploy MyERC1155Token
  const HeroItem = await ethers.getContractFactory("HeroItem");
  const heroItem = await HeroItem.deploy(
    "https://abcoathup.github.io/SampleERC1155/api/token/{id}.json"
  );
  await heroItem.deployed();
  console.log("HeroItem address: ", heroItem.address);
  const HeroItemAddressData = {
    HeroItemAddress: heroItem.address,
  };
  const HeroItemDataJsonData = JSON.stringify(HeroItemAddressData, null, 2);
  fs.writeFileSync(HeroItemFilePath, HeroItemDataJsonData);

  // deploy NFTMarketplace

  const Wibu_NFTMarketplace = await ethers.getContractFactory(
    "HeroMarketPlace"
  );
  const HeroMarketPlace = await Wibu_NFTMarketplace.deploy(
    token.address,
    nft.address,
    heroItem.address
  );
  console.log("NFTAddress: ", nft.address);
  console.log("tokenAddress: ", token.address);
  console.log("heroItemAddress: ", heroItem.address);
  await HeroMarketPlace.deployed();
  console.log("HeroMarketPlace address: ", HeroMarketPlace.address);
  const HeroMarketPlaceData = {
    HeroMarketPlaceAddress: HeroMarketPlace.address,
  };
  const HeroMarketPlaceJsonData = JSON.stringify(HeroMarketPlaceData, null, 2);
  fs.writeFileSync(HeroMarketPlaceFilePath, HeroMarketPlaceJsonData);

  console.log("Deployment completed. Data saved to respective JSON files.");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
