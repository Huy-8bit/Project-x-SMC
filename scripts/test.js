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

    // it("Should crete NFT", async function () {
    //   const price = await baseXNFT.getPrice();
    //   const tokenURI =
    //     "https://red-flying-lynx-578.mypinata.cloud/ipfs/QmZqeKmGoquMG5nFCb9q82WHR4F1Rd3WeMbW1QEPJifHsc/nft.json";
    //   const result = await baseXNFT.mintNFT(tokenURI, {
    //     value: price,
    //   });
    //   console.log("result: ", result);
    // });

    // it("Should return all My NFT", async function () {
    //   const result = await baseXNFT.getAllMyNft();
    //   console.log("result: ", result);
    // });
    // it("Should return NFTRank of nft ", async function () {
    //   const tokenId =
    //     "30997013614142406733736512295088090167947821475420338503716517640044622001673";
    //   const NFTRank = await baseXNFT.getNFTRank(tokenId);
    //   console.log("NFTRank: ", NFTRank);
    // });
    // it("Should withdraw eth", async function () {
    //   const result = await baseXNFT.withdraw();
    //   console.log("result: ", result);
    // });
  });

  // describe("NFT", function () {
  //   it("should return address", async function () {
  //     console.log("owner: ", owner.address);
  //     console.log("NFTAddress: ", NFTAddress);
  //     console.log("tokenAddress: ", tokenAddress);
  //     console.log("baseXItem: ", BaseXItemAddress);
  //     console.log("BaseXMarketPlaceAddress: ", BaseXMarketPlaceAddress);
  //   });
  //   it("Should transfer baseXToken", async function () {
  //     const amount = utils.parseEther("15000000000");
  //     const result = await baseXToken.transfer(
  //       "0xf30607e0cdEc7188d50d2bb384073bF1D5b02fA4",
  //       amount
  //     );
  //     console.log("result: ", result);
  //   });
  //   it("Should mint a new token and return the correct tokenURI", async function () {
  //     const tokenId = 13;
  //     const tokenURI = "my-token-uri";
  //     const result = await baseXItem.mint(
  //       owner.address,
  //       tokenId,
  //       1000,
  //       tokenURI
  //     );
  //     console.log("result: ", result);
  //   });
  //   it("Should return token uri", async function () {
  //     const tokenId = 13;
  //     const actualTokenURI = await BaseXItem.uri(tokenId);
  //     console.log("actualTokenURI: ", actualTokenURI);
  //   });
  //   it("Should send token", async function () {
  //     const tokenId = 12;
  //     const amount = 5;
  //     const result = await baseXItem.safeTransferFrom(
  //       owner.address,
  //       addres_recipient,
  //       tokenId,
  //       amount,
  //       "0x"
  //     );
  //     console.log("result: ", result);
  //   });
  //   it("Should return balance of owner", async function () {
  //     const balance = await baseXNFT.checkBalance();
  //     console.log("balance: ", balance.toString());
  //   });
  //   it("Should create info NFT random", async function () {
  //     const result = await baseXNFT.calculateRandomNFTInfo();
  //     await new Promise((resolve) => setTimeout(resolve, 20000));
  //     console.log("result: ", result);
  //   });
  //   it("Should get info NFT random", async function () {
  //     const result = await baseXNFT.getMintedNFTInfo(owner.address);
  //     console.log("result: ", result);
  //   });
  //   it("Should crete NFT", async function () {
  //     const getInfoNFT = await baseXNFT.getMintedNFTInfo(owner.address);
  //     console.log("getInfoNFT: ", getInfoNFT);
  //     const tokenId = getInfoNFT.tokenId.toString();
  //     const rank = getInfoNFT.rank.toString();
  //     const price = getInfoNFT.mintingPrice.toString();
  //     console.log("tokenId: ", tokenId);
  //     console.log("rank: ", rank);
  //     console.log("price: ", price);
  //     const tokenURI =
  //       "https://red-flying-lynx-578.mypinata.cloud/ipfs/QmZqeKmGoquMG5nFCb9q82WHR4F1Rd3WeMbW1QEPJifHsc/nft.json";
  //     const result = await baseXNFT.mintNFTWithId(tokenId, tokenURI, {
  //       value: price,
  //     });
  //     console.log("result: ", result);
  //   });
  //   it("Should return NFTRank of nft ", async function () {
  //     const tokenId = 30748987;
  //     const NFTRank = await baseXNFT.getNFTRank(tokenId);
  //     console.log("NFTRank: ", NFTRank);
  //   });
  //   it("Should withdraw eth", async function () {
  //     const result = await baseXNFT.withdraw();
  //     console.log("result: ", result);
  //   });
  //   it("Should edit price", async function () {
  //     const rank = 3;
  //     const price = utils.parseEther("3");
  //     const result = await baseXNFT.editPriceMint(rank, price);
  //     console.log("result: ", result);
  //   });
  //   it("Should listed NFT on marketplace", async function () {
  //     const tokenId = 7;
  //     const result = await baseXMarketPlace.ListedNFT(
  //       tokenId,
  //       utils.parseEther("100000")
  //     );
  //     console.log("result: ", result);
  //   });
  //   it("should approve nft", async function () {
  //     const tokenId = 7;
  //     const result = await baseXNFT.approve(BaseXMarketPlaceAddress, tokenId);
  //     console.log("result: ", result);
  //   });
  //   it("buy nft ", async function () {
  //     const tokenId = 7;
  //     const NftBuyInfo = await baseXMarketPlace.getListedTokenForId(tokenId);
  //     await baseXToken.approve(BaseXMarketPlaceAddress, NftBuyInfo.price);
  //     const result = await baseXMarketPlace.buyNft(tokenId);
  //     console.log("result: ", result);
  //   });
  // });
});
