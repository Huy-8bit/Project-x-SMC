// test nft marketplace

const { expect } = require("chai");
const { ethers } = require("hardhat");
const fs = require("fs");
const { id } = require("ethers/lib/utils");
const utils = ethers.utils;
require("dotenv").config();

// comandline: npx hardhat test scripts/test.js --network sepolia

const nftFilePath = "./deployment/BaseXNFT.json";
const baseXNFTLibraryFilePath = "./deployment/BaseXNFTLibrary.json";

// Read data from an NFT . JSON file
const nftJsonData = fs.readFileSync(nftFilePath, "utf-8");
const nftData = JSON.parse(nftJsonData);
const NFTAddress = nftData.BaseXNFTAddress;

// read data from an BaseXNFTLibrary . JSON file
const baseXNFTLibraryJsonData = fs.readFileSync(
  baseXNFTLibraryFilePath,
  "utf-8"
);
const baseXNFTLibraryData = JSON.parse(baseXNFTLibraryJsonData);
const baseXNFTLibraryAddress = baseXNFTLibraryData.BaseXNFTLibraryAddress;

const addres_recipient = "0xFd883589837bEEFf3dFdB97A821E0c71FF9BA20A";

describe("NFTMarketplace", function () {
  beforeEach(async function () {
    BaseXNFTLibrary = await ethers.getContractFactory("BaseXNFTLibrary");
    baseXNFTLibrary = await BaseXNFTLibrary.attach(baseXNFTLibraryAddress);

    BaseXNFT = await ethers.getContractFactory("BaseXNFT", {
      libraries: {
        BaseXNFTLibrary: baseXNFTLibraryAddress,
      },
    });
    baseXNFT = await BaseXNFT.attach(NFTAddress);

    [owner] = await ethers.getSigners();
  });

  describe("NFT Mint test", function () {
    it("should return address", async function () {
      console.log("owner: ", owner.address);
      console.log("NFTAddress: ", NFTAddress);
    });

    // it("Should edit limit", async function () {
    //   const result = await baseXNFT.editLimitMint(1000);
    //   console.log("result: ", result);
    // });

    // it("Should edit PriceMint", async function () {
    //   const result = await baseXNFT.editPriceMint(
    //     ethers.utils.parseEther("0.00054")
    //   );
    //   await new Promise((resolve) => setTimeout(resolve, 15000));
    //   console.log("result: ", result.hash);
    // });

    // it("Should edit add Free mint address", async function () {
    //   const listAddress = [
    //     owner.address.toString(),
    //     "0xf30607e0cdEc7188d50d2bb384073bF1D5b02fA4",
    //   ];

    //   for (var i = 0; i < listAddress.length; i++) {
    //     const result = await baseXNFT.addFreeMintAddress(listAddress[i], {
    //       // gasLimit: 272441000000000,
    //     });
    //     console.log("result: ", result.hash);
    //     await new Promise((resolve) => setTimeout(resolve, 15000));
    //   }
    // });

    // it("Should edit changeRarity", async function () {
    //   const result = await baseXNFT.changeRarity([25, 25, 25, 25]);
    //   console.log("result: ", result);
    // });

    it("Should edit mintChangedFlag", async function () {
      const result = await baseXNFT.mintChangedFlag(true);
      console.log("result: ", result);
      await new Promise((resolve) => setTimeout(resolve, 25000));
    });

    // it("Should edit remove Free mint address", async function () {
    //   const listAddress = [
    //     "0xFd883589837bEEFf3dFdB97A821E0c71FF9BA20A",
    //     "0xf30607e0cdEc7188d50d2bb384073bF1D5b02fA4",
    //     "0xC77E5F3B7099bA3b3A4b20292d010696b97177fc",
    //   ];
    //   for (var i = 0; i < listAddress.length; i++) {
    //     const result = await baseXNFT.removeFreeMintAddress(listAddress[i]);
    //     console.log("result: ", result.hash);
    //     await new Promise((resolve) => setTimeout(resolve, 15000));
    //   }
    // });

    it("Should crete NFT", function (done) {
      (async () => {
        for (var i = 0; i < 100; i++) {
          console.log("minter: ", owner.address);
          const price = await baseXNFT.getPrice(); // 0.00054
          console.log("price: ", price.toString());
          const result = await baseXNFT.mint({
            value: price,
            // gasLimit: 272441,
          });
          console.log("result: ", result.hash);
          await new Promise((resolve) => setTimeout(resolve, 15000));
        }
      })().then(done);
    });

    // it("Should return top mint", async function () {
    //   const result = await baseXNFT.getTopMintNFT(2);
    //   console.log("result: ", result);
    // });

    // it("Should return all rank My NFT", async function () {
    //   const result = await baseXNFT.getMintedNFTs(
    //     "0xe8E8FfF9a25F17e0fACE7795993a39eb3032adDc"
    //   );
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

    // it("Should return all point", async function () {
    //   const listAddress = await baseXNFT.getTopMintNFT(2);
    //   for (var i = 0; i < listAddress.length; i++) {
    //     console.log("Address: ", listAddress[i]);
    //     const result = await baseXNFT.getPoint(listAddress[i]);
    //     console.log("point: ", result);
    //     const listNFT = await baseXNFT.getMintedNFTs(listAddress[i]);
    //     console.log("listNFT: ", listNFT);
    //   }
    // });

    // it("Should return all My NFT", async function () {
    //   const result = await baseXNFT.getMintedNFTs(
    //     "0xf30607e0cdEc7188d50d2bb384073bF1D5b02fA4"
    //   );
    //   console.log("result: ", result);
    // });

    // it("Should return NFTRank of nft ", async function () {
    //   const tokenId =
    //     "86387482172344164460254970375293145769050953289522437300678736851351432146875";
    //   const NFTRank = await baseXNFT.getNFTRank(tokenId);
    //   console.log("NFTRank: ", NFTRank);
    // });

    // it("Should changeWithdrawFlag  eth", async function () {
    //   const result = await baseXNFT.changeWithdrawFlag();
    //   console.log("result: ", result);
    // });

    // it("Should withdraw eth", async function () {
    //   const result = await baseXNFT.withdraw();
    //   console.log("result: ", result);
    // });

    // it("Should Rewards", async function () {
    //   const result = await baseXNFT.withdrawRewards(5, 40);
    //   console.log("result: ", result);
    // });
  });
});
