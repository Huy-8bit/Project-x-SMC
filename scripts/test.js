// test nft marketplace

const { expect } = require("chai");
const { ethers } = require("hardhat");
const fs = require("fs");
const { id } = require("ethers/lib/utils");
const utils = ethers.utils;
// comandline: npx hardhat test scripts/test.js --network sepolia

const nftFilePath = "./deployment/HeroNFT.json";
const HeroTokenFilePath = "./deployment/HeroToken.json";
const HeroItemFilePath = "./deployment/HeroItem.json";
const HeroMarketPlaceFilePath = "./deployment/HeroMarketPlace.json";

// Read data from an NFT . JSON file
const nftJsonData = fs.readFileSync(nftFilePath, "utf-8");
const nftData = JSON.parse(nftJsonData);
const NFTAddress = nftData.HeroNFTAddress;

// Read data from WibuToken's JSON file
const HeroTokenJsonData = fs.readFileSync(HeroTokenFilePath, "utf-8");
const heroTokenData = JSON.parse(HeroTokenJsonData);
const tokenAddress = heroTokenData.HeroTokenAddress;

// Read data from HeroItem's JSON file
const HeroItemJsonData = fs.readFileSync(HeroItemFilePath, "utf-8");
const HeroItemData = JSON.parse(HeroItemJsonData);
const HeroItemAddress = HeroItemData.HeroItemAddress;

// read data from HeroMarketPlace's JSON file
const HeroMarketPlaceJsonData = fs.readFileSync(
  HeroMarketPlaceFilePath,
  "utf-8"
);
const HeroMarketPlaceData = JSON.parse(HeroMarketPlaceJsonData);
const HeroMarketPlaceAddress = HeroMarketPlaceData.HeroMarketPlaceAddress;

const addres_recipient = "0xFd883589837bEEFf3dFdB97A821E0c71FF9BA20A";

describe("NFTMarketplace", function () {
  let WibuMarketPlace;
  let wibuMarketPlace;
  let owner;

  beforeEach(async function () {
    HeroNFT = await ethers.getContractFactory("HeroNFT");
    heroNFT = await HeroNFT.attach(NFTAddress);
    HeroToken = await ethers.getContractFactory("HeroToken");
    heroToken = await HeroToken.attach(tokenAddress);
    HeroItem = await ethers.getContractFactory("HeroItem");
    heroItem = await HeroItem.attach(HeroItemAddress);
    HeroMarketPlace = await ethers.getContractFactory("HeroMarketPlace");
    heroMarketPlace = await HeroMarketPlace.attach(HeroMarketPlaceAddress);
    [owner] = await ethers.getSigners();
  });

  describe("NFT", function () {
    // it("should return address", async function () {
    //   console.log("owner: ", owner.address);
    //   console.log("NFTAddress: ", NFTAddress);
    //   console.log("tokenAddress: ", tokenAddress);
    //   console.log("heroItem: ", HeroItemAddress);
    //   console.log("HeroMarketPlaceAddress: ", HeroMarketPlaceAddress);
    // });
    // it("Should transfer heroToken", async function () {
    //   const amount = utils.parseEther("15000000000");
    //   const result = await heroToken.transfer(
    //     "0xf30607e0cdEc7188d50d2bb384073bF1D5b02fA4",
    //     amount
    //   );
    //   console.log("result: ", result);
    // });
    // it("Should mint a new token and return the correct tokenURI", async function () {
    //   const tokenId = 10;
    //   const tokenURI = "my-token-uri";
    //   const result = await HeroItem.mint(
    //     owner.address,
    //     tokenId,
    //     2,
    //     tokenURI
    //   );
    //   console.log("result: ", result);
    // });
    // it("Should return token uri", async function () {
    //   const tokenId = 13;
    //   const actualTokenURI = await HeroItem.uri(tokenId);
    //   console.log("actualTokenURI: ", actualTokenURI);
    // });
    // it("Should send token", async function () {
    //   const tokenId = 10;
    //   const amount = 5;
    //   const result = await HeroItem.safeTransferFrom(
    //     owner.address,
    //     addres_recipient,
    //     tokenId,
    //     amount,
    //     "0x"
    //   );
    //   console.log("result: ", result);
    // });
    // it("crete NFT", async function () {
    //   const tokenId = 7;
    //   const tokenURI =
    //     "https://ipfs.io/ipfs/QmdqjbEdpXpbxP5Bs4KkqYs44eDwufWLW4NfqPt2tZZeEA?filename=photo1.json";
    //   const result = await heroNFT.mintNFTWithId(tokenId, tokenURI, 3);
    //   console.log("result: ", result);
    // });
    // it("Should listed NFT on marketplace", async function () {
    //   const tokenId = 7;
    //   const result = await heroMarketPlace.ListedNFT(
    //     tokenId,
    //     utils.parseEther("100000")
    //   );
    //   console.log("result: ", result);
    // });
    // it("should approve nft", async function () {
    //   const tokenId = 7;
    //   const result = await heroNFT.approve(HeroMarketPlaceAddress, tokenId);
    //   console.log("result: ", result);
    // });
    // it("buy nft ", async function () {
    //   const tokenId = 7;
    //   const NftBuyInfo = await heroMarketPlace.getListedTokenForId(tokenId);
    //   await heroToken.approve(HeroMarketPlaceAddress, NftBuyInfo.price);
    //   const result = await heroMarketPlace.buyNft(tokenId);
    //   console.log("result: ", result);
    // });
  });
});
