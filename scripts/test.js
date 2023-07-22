// test nft marketplace

const { expect } = require("chai");
const { ethers } = require("hardhat");
const fs = require("fs");
const { id } = require("ethers/lib/utils");

// comandline: npx hardhat test scripts/test.js --network sepolia

const nftFilePath = "./deployment/nft.json";
const HeroTokenFilePath = "./deployment/Token.json";

// Read data from an NFT . JSON file
const nftJsonData = fs.readFileSync(nftFilePath, "utf-8");
const nftData = JSON.parse(nftJsonData);
const NFTAddress = nftData.HeroNFTAddress;

// Read data from WibuToken's JSON file
const HeroTokenJsonData = fs.readFileSync(HeroTokenFilePath, "utf-8");
const heroTokenData = JSON.parse(HeroTokenJsonData);
const tokenAddress = heroTokenData.HeroTokenAddress;

const addres_recipient = "0xFd883589837bEEFf3dFdB97A821E0c71FF9BA20A";

describe("NFTMarketplace", function () {
  let WibuMarketPlace;
  let wibuMarketPlace;
  let owner;

  beforeEach(async function () {
    console.log("start test with before each: ");
    HeroNFT = await ethers.getContractFactory("HeroNFT");
    heroNFT = await HeroNFT.attach(NFTAddress);
    [owner] = await ethers.getSigners();
    console.log("owner: ", owner.address);
    console.log("NFTAddress: ", NFTAddress);
    console.log("tokenAddress: ", tokenAddress);
  });

  describe("NFT", function () {
    // it("create nft 1 ", async function () {
    //   const link_nft =
    //     "https://wallpapers.com/images/high/sasuke-silhouette-4k-sqbl3rfuo2qpepuh.webp";
    //   console.log("link nft: ", link_nft);
    //   const newToken = await heroNFT.createNFT(link_nft);
    //   console.log("newToken: ", newToken);
    // });
    // it("create nft 2 ", async function () {
    //   const link_nft =
    //     "https://wallpapers.com/images/hd/naruto-characters-64pjyoj5g8xfatla.webp";
    //   console.log("link nft: ", link_nft);
    //   const newToken = await heroNFT.mintNFTWithId("123123123", link_nft);
    //   console.log("newToken: ", newToken);
    // });
    it("mint NFT with ID", async function () {
      const tokenId = 7;
      const link_nft =
        "https://ipfs.io/ipfs/QmdqjbEdpXpbxP5Bs4KkqYs44eDwufWLW4NfqPt2tZZeEA?filename=photo1.json";
      const rank = 3; // Replace with the desired rank value (e.g., 0 for Common, 1 for Rare, 2 for Epic, 3 for Legendary)

      const result = await heroNFT.mintNFTWithId(tokenId, link_nft, rank);
      console.log("result: ", result);
    });
  });
});
