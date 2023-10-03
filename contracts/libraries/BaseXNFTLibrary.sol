// SPDX-License-Identifier: MIT

// library for baseXNFT
pragma solidity ^0.8.0;

library BaseXNFTLibrary {
    struct NFTUrls {
        string urlCommon;
        string urlRare;
        string urlEpic;
        string urlLegendary;
    }
    enum Rank {
        Common,
        Rare,
        Epic,
        Legendary
    }
    struct NFT {
        uint256 tokenId;
        Rank rank;
    }

    function calculateNFTInfo(
        uint256 blockNumber,
        uint256 blockTimestamp,
        uint256 blockDifficulty,
        address msgSender,
        address lastAddress,
        uint256[] memory totalMintWithRank,
        uint256 totalSupply
    ) external view returns (NFT memory) {
        uint256 randomNumber = uint256(
            keccak256(
                abi.encodePacked(
                    blockNumber,
                    blockTimestamp,
                    blockDifficulty,
                    msgSender,
                    lastAddress
                )
            )
        );

        uint256 calculates = randomNumber % 100;
        Rank randomRank;

        if (calculates < 60 && calculates >= 0) {
            // it's 60% for common
            randomRank = Rank.Common;
        } else if (calculates < 85 && calculates >= 60) {
            // it's 25% for rare
            randomRank = Rank.Rare;
        } else if (calculates < 95 && calculates >= 85) {
            // it's 10% for epic
            randomRank = Rank.Epic;
        } else {
            randomRank = Rank.Legendary;
        }

        NFT memory newNFT = NFT(0, randomRank);

        return newNFT;
    }

    function calculatePrice(
        uint256 _totalSupply,
        uint256 _limitMintWhilteList
    ) external view returns (uint256) {
        uint256 price = 0;
        if (_totalSupply + _limitMintWhilteList >= 40) {
            price = 0.00002 ether;
        } else if (_totalSupply + _limitMintWhilteList >= 10) {
            price = 0.00001 ether;
        } else {
            price = 0.000000 ether;
        }

        return price;
    }
}

// function calculateNFTInfo(
//     uint256 blockNumber,
//     uint256 blockTimestamp,
//     uint256 blockDifficulty,
//     address msgSender,
//     address lastAddress,
//     uint256[] memory totalMintWithRank,
//     uint256 totalSupply
// ) external view returns (NFT memory) {
//     uint256 randomNumber = uint256(
//         keccak256(
//             abi.encodePacked(
//                 blockNumber,
//                 blockTimestamp,
//                 blockDifficulty,
//                 msgSender,
//                 lastAddress
//             )
//         )
//     );

//     Rank randomRank;
//     uint256 availableRank;

//     if (totalSupply < 1000) {
//         uint256 calculates = randomNumber % 100;
//         if (calculates < 60) {
//             availableRank = uint256(Rank.Common);
//         } else if (calculates < 85) {
//             availableRank = uint256(Rank.Rare);
//         } else if (calculates < 95) {
//             availableRank = uint256(Rank.Epic);
//         } else {
//             availableRank = uint256(Rank.Legendary);
//         }

//         if (
//             totalMintWithRank[availableRank] < getRankLimit(availableRank)
//         ) {
//             randomRank = Rank(availableRank);
//         } else {
//             // If the rank limit has been reached, reroll for a new rank.
//             randomRank = getRandomRank(totalMintWithRank);
//         }
//     } else {
//         // Total supply reached, no more NFTs can be minted.
//         randomRank = Rank.Legendary;
//     }

//     NFT memory newNFT = NFT(0, randomRank);

//     return newNFT;
// }

// function getRankLimit(uint256 rank) internal pure returns (uint256) {
//     if (rank == uint256(Rank.Common)) {
//         return 600;
//     } else if (rank == uint256(Rank.Rare)) {
//         return 250;
//     } else if (rank == uint256(Rank.Epic)) {
//         return 100;
//     } else {
//         return 50;
//     }
// }

// function getRandomRank(
//     uint256[] memory totalMintWithRank
// ) internal view returns (Rank) {
//     while (true) {
//         uint256 randomRank = uint256(Rank.Common) +
//             (uint256(blockhash(block.number - 1)) % 4);
//         if (totalMintWithRank[randomRank] < getRankLimit(randomRank)) {
//             return Rank(randomRank);
//         }
//     }
// }
