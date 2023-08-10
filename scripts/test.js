// test nft marketplace

const { expect } = require("chai");
const { ethers } = require("hardhat");
const fs = require("fs");
const { id } = require("ethers/lib/utils");
const utils = ethers.utils;
require("dotenv").config();
// const { WETH } = require("@uniswap/v2-periphery");
// comandline: npx hardhat test scripts/test.js --network sepolia

const nftFilePath = "./deployment/BaseXNFT.json";
// const BaseXTokenFilePath = "./deployment/BaseXToken.json";
const BaseXItemFilePath = "./deployment/BaseXItem.json";
// const BaseXMarketPlaceFilePath = "./deployment/BaseXMarketPlace.json";

// Read data from an NFT . JSON file
const nftJsonData = fs.readFileSync(nftFilePath, "utf-8");
const nftData = JSON.parse(nftJsonData);
const NFTAddress = nftData.BaseXNFTAddress;

// // Read data from BaseXToken's JSON file
// const BaseXTokenJsonData = fs.readFileSync(BaseXTokenFilePath, "utf-8");
// const baseXTokenData = JSON.parse(BaseXTokenJsonData);
// const tokenAddress = baseXTokenData.BaseXTokenAddress;

// // Read data from BaseXItem's JSON file
// const BaseXItemJsonData = fs.readFileSync(BaseXItemFilePath, "utf-8");
// const BaseXItemData = JSON.parse(BaseXItemJsonData);
// const BaseXItemAddress = BaseXItemData.BaseXItemAddress;

// // read data from BaseXMarketPlace's JSON file
// const BaseXMarketPlaceJsonData = fs.readFileSync(
//   BaseXMarketPlaceFilePath,
//   "utf-8"
// );
// const BaseXMarketPlaceData = JSON.parse(BaseXMarketPlaceJsonData);
// const BaseXMarketPlaceAddress = BaseXMarketPlaceData.BaseXMarketPlaceAddress;

const addres_recipient = "0xFd883589837bEEFf3dFdB97A821E0c71FF9BA20A";

describe("NFTMarketplace", function () {
  beforeEach(async function () {
    BaseXNFT = await ethers.getContractFactory("BaseXNFT");
    baseXNFT = await BaseXNFT.attach(NFTAddress);
    // BaseXToken = await ethers.getContractFactory("BaseXToken");
    // baseXToken = await BaseXToken.attach(tokenAddress);
    // BaseXItem = await ethers.getContractFactory("BaseXItem");
    // baseXItem = await BaseXItem.attach(BaseXItemAddress);
    // BaseXMarketPlace = await ethers.getContractFactory("BaseXMarketPlace");
    // baseXMarketPlace = await BaseXMarketPlace.attach(BaseXMarketPlaceAddress);
    [owner] = await ethers.getSigners();
  });

  describe("NFT Mint test", function () {
    it("should return address", async function () {
      console.log("owner: ", owner.address);
      console.log("NFTAddress: ", NFTAddress);
      // console.log("tokenAddress: ", tokenAddress);
      // console.log("baseXItem: ", BaseXItemAddress);
      // console.log("BaseXMarketPlaceAddress: ", BaseXMarketPlaceAddress);
    });

    // it("Should edit limit", async function () {
    //   const result = await baseXNFT.editLimitMint(1000);
    //   console.log("result: ", result);
    // });

    // it("Should crete NFT", function (done) {
    //   (async () => {
    //     for (var i = 0; i < 4; i++) {
    //       const price = await baseXNFT.getPrice();
    //       const tokenURI =
    //         "https://red-flying-lynx-578.mypinata.cloud/ipfs/QmZqeKmGoquMG5nFCb9q82WHR4F1Rd3WeMbW1QEPJifHsc/nft.json";
    //       const result = await baseXNFT.mintNFT(tokenURI, {
    //         value: price,
    //       });
    //       console.log("result: ", result);
    //       await new Promise((resolve) => setTimeout(resolve, 20000));
    //     }
    //     done(); // Gọi hàm done() để thông báo rằng kiểm thử đã hoàn thành
    //   })();
    // });

    // it("Should return all rank My NFT", async function () {
    //   const result = await baseXNFT.getMintedNFTs(owner.address);
    //   // console.log("result: ", result);
    //   let arrayRank = [];
    //   for (var i = 0; i < result.length; i++) {
    //     const element = result[i];
    //     arrayRank.push(element.toString());
    //   }
    //   console.log("arrayRank: ", arrayRank);

    //   for (var i = 0; i < arrayRank.length; i++) {
    //     const rank = arrayRank[i];
    //     const result = await baseXNFT.getNFTRank(arrayRank[i]);
    //     console.log("result: ", result);
    //   }
    // });

    // it("Should return point", async function () {
    //   const result = await baseXNFT.getPoint(owner.address);
    //   console.log("result: ", result);
    // });

    // it("Should return all My NFT", async function () {
    //   const result = await baseXNFT.getMintedNFTs(owner.address);
    //   console.log("result: ", result);
    // });

    // it("Should return NFTRank of nft ", async function () {
    //   const tokenId =
    //     "86387482172344164460254970375293145769050953289522437300678736851351432146875";
    //   const NFTRank = await baseXNFT.getNFTRank(tokenId);
    //   console.log("NFTRank: ", NFTRank);
    // });

    // it("Should withdraw eth", async function () {
    //   const result = await baseXNFT.withdraw();
    //   console.log("result: ", result);
    // });
  });
});
