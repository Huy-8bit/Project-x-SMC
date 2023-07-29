// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./HeroMarketPlace.sol";

contract HeroNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;
    address public owner;
    string public NFT_url;
    uint256 public limitMint;
    // price for each rank
    uint256[4] public price = [0.1 ether, 0.5 ether, 1 ether, 2 ether];
    enum Rank {
        Common,
        Rare,
        Epic,
        Legendary
    }

    struct NFT {
        uint256 tokenId;
        string tokenURI;
        Rank rank;
    }

    struct MintedNFTInfo {
        uint256 tokenId;
        uint256 rank;
        uint256 mintingPrice;
    }

    mapping(uint256 => NFT) public NFTs;

    constructor() ERC721("Hero NFT", "HR") {
        owner = msg.sender;
        limitMint = 2;
    }

    function withdraw() public payable {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function editLimitMint(uint256 _newLimit) public {
        require(msg.sender == owner, "Only owner can edit limit");
        limitMint = _newLimit;
    }

    function mintNFTWithId(
        uint256 _tokenId,
        string memory _NFT_url,
        Rank _rank
    ) public payable {
        require(!_exists(_tokenId), "Token ID already exists");
        require(
            balanceOf(msg.sender) < limitMint,
            "You have reached the limit of minting"
        );
        require(
            _rank == Rank.Common ||
                _rank == Rank.Rare ||
                _rank == Rank.Epic ||
                _rank == Rank.Legendary,
            "Invalid rank"
        );
        uint256 mintingPrice = getPrice(uint256(_rank));
        require(msg.value >= mintingPrice, "Insufficient ether sent");
        _tokenIds.increment();

        _mint(msg.sender, _tokenId);
        _setTokenURI(_tokenId, _NFT_url);

        NFTs[_tokenId] = NFT(_tokenId, _NFT_url, _rank);
    }

    function calculateRandomNFTInfo()
        public
        view
        returns (MintedNFTInfo memory)
    {
        require(balanceOf(msg.sender) < 2, "You can only own 2 NFTs at most");

        // Generate a random number between 0 and 99 (inclusive)
        uint256 randomNumber = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
            )
        ) % 100;

        // Define the ranges for each rarity
        uint256 commonThreshold = 50; // 0 - 49 (50%)
        uint256 rareThreshold = commonThreshold + 30; // 50 - 79 (30%)
        uint256 epicThreshold = rareThreshold + 15; // 80 - 94 (15%)
        uint256 legendaryThreshold = epicThreshold + 5; // 95 - 99 (5%)

        Rank randomRank;

        // Determine the rarity based on the random number generated
        if (randomNumber < commonThreshold) {
            randomRank = Rank.Common;
        } else if (randomNumber < rareThreshold) {
            randomRank = Rank.Rare;
        } else if (randomNumber < epicThreshold) {
            randomRank = Rank.Epic;
        } else {
            randomRank = Rank.Legendary;
        }

        // Get the minting price for the chosen rarity
        uint256 mintingPrice = getPrice(uint256(randomRank));

        return MintedNFTInfo(randomNumber, uint256(randomRank), mintingPrice);
    }

    function editPriceMint(uint256 _rank, uint256 _newPrice) public {
        require(msg.sender == owner, "Only owner can edit price");
        price[_rank] = _newPrice;
    }

    function getPrice(uint256 _rank) public view returns (uint256) {
        return price[_rank];
    }

    function getAllMyNft() public view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](_tokenIds.current());
        uint256 counter = 0;
        for (uint256 i = 1; i <= _tokenIds.current(); i++) {
            if (ownerOf(i) == msg.sender) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function getNFTURI(uint256 tokenId) public view returns (string memory) {
        return tokenURI(tokenId);
    }

    function getNFTRank(uint256 tokenId) public view returns (Rank) {
        require(_exists(tokenId), "Token ID does not exist");

        return NFTs[tokenId].rank;
    }

    function transferNFT(address _to, uint256 _tokenId) public {
        safeTransferFrom(msg.sender, _to, _tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function getAllMintedNFTs() public view returns (NFT[] memory) {
        NFT[] memory mintedNFTs = new NFT[](_tokenIds.current());

        for (uint256 i = 1; i <= _tokenIds.current(); i++) {
            if (_exists(i)) {
                mintedNFTs[i - 1] = NFTs[i];
            }
        }

        return mintedNFTs;
    }
}

// pragma solidity ^0.8.0;

// import "hardhat/console.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "./HeroMarketPlace.sol";

// contract HeroNFT is ERC721URIStorage {
//     using Counters for Counters.Counter;
//     Counters.Counter private _tokenIds;
//     Counters.Counter private _itemsSold;
//     address public owner;
//     string public NFT_url;
//     // price for each rank
//     uint256[4] public price = [0.1 ether, 0.5 ether, 1 ether, 2 ether];
//     enum Rank {
//         Common,
//         Rare,
//         Epic,
//         Legendary
//     }

//     struct NFT {
//         uint256 tokenId;
//         string tokenURI;
//         Rank rank;
//     }

//     struct MintedNFTInfo {
//         uint256 tokenId;
//         uint256 rank;
//         uint256 mintingPrice;
//     }

//     mapping(uint256 => NFT) public NFTs;

//     constructor() ERC721("Hero NFT", "HR") {
//         owner = msg.sender;
//     }

//     function withdraw() public payable {
//         require(msg.sender == owner, "Only owner can withdraw");
//         uint256 balance = address(this).balance;
//         payable(msg.sender).transfer(balance);
//     }

//     function mintNFTWithId(
//         uint256 _tokenId,
//         string memory _NFT_url,
//         Rank _rank
//     ) public payable {
//         require(!_exists(_tokenId), "Token ID already exists");
//         require(
//             balanceOf(msg.sender) < 2 || msg.sender == owner,
//             "You can only own 2 NFTs at most"
//         );
//         require(
//             _rank == Rank.Common ||
//                 _rank == Rank.Rare ||
//                 _rank == Rank.Epic ||
//                 _rank == Rank.Legendary,
//             "Invalid rank"
//         );
//         uint256 mintingPrice = getPrice(uint256(_rank));
//         require(msg.value >= mintingPrice, "Insufficient ether sent");
//         _tokenIds.increment();

//         _mint(msg.sender, _tokenId);
//         _setTokenURI(_tokenId, _NFT_url);

//         NFTs[_tokenId] = NFT(_tokenId, _NFT_url, _rank);
//     }

//     function mintRandomNFT(string memory _NFT_url) public payable {
//         require(
//             balanceOf(msg.sender) < 2 || msg.sender == owner,
//             "You can only own 2 NFTs at most"
//         );

//         // Generate a random number between 0 and 2^256-1
//         uint256 randomNumber = uint256(
//             keccak256(
//                 abi.encodePacked(
//                     block.timestamp,
//                     block.difficulty,
//                     msg.sender,
//                     _NFT_url
//                 )
//             )
//         );

//         // Get the last 8 digits of the random number to use as tokenId
//         uint256 newTokenId = randomNumber % 100000000;

//         // Define the ranges for each rarity
//         uint256 commonThreshold = 50; // 0 - 49 (50%)
//         uint256 rareThreshold = commonThreshold + 30; // 50 - 79 (30%)
//         uint256 epicThreshold = rareThreshold + 15; // 80 - 94 (15%)
//         uint256 legendaryThreshold = epicThreshold + 5; // 95 - 99 (5%)

//         Rank randomRank;

//         // Determine the rarity based on the random number generated
//         if (randomNumber < commonThreshold) {
//             randomRank = Rank.Common;
//         } else if (randomNumber < rareThreshold) {
//             randomRank = Rank.Rare;
//         } else if (randomNumber < epicThreshold) {
//             randomRank = Rank.Epic;
//         } else {
//             randomRank = Rank.Legendary;
//         }

//         // Get the minting price for the chosen rarity
//         uint256 mintingPrice = getPrice(uint256(randomRank));
//         require(msg.value >= mintingPrice, "Insufficient ether sent");

//         // Increment the tokenIds counter
//         _tokenIds.increment();

//         // Mint the NFT with the generated token ID and given URL
//         _mint(msg.sender, newTokenId);
//         _setTokenURI(newTokenId, _NFT_url);

//         // Store the NFT details in the mapping
//         NFTs[newTokenId] = NFT(newTokenId, _NFT_url, randomRank);
//     }

//     // function mintRandomNFT(string memory _NFT_url) public payable {
//     //     require(
//     //         balanceOf(msg.sender) < 2 || msg.sender == owner,
//     //         "You can only own 2 NFTs at most"
//     //     );

//     //     // Generate a random number between 0 and 99 (inclusive)
//     //     uint256 randomNumber = uint256(
//     //         keccak256(
//     //             abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
//     //         )
//     //     ) % 100;

//     //     // Define the ranges for each rarity
//     //     uint256 commonThreshold = 50; // 0 - 49 (50%)
//     //     uint256 rareThreshold = commonThreshold + 30; // 50 - 79 (30%)
//     //     uint256 epicThreshold = rareThreshold + 15; // 80 - 94 (15%)
//     //     uint256 legendaryThreshold = epicThreshold + 5; // 95 - 99 (5%)

//     //     Rank randomRank;

//     //     // Determine the rarity based on the random number generated
//     //     if (randomNumber < commonThreshold) {
//     //         randomRank = Rank.Common;
//     //     } else if (randomNumber < rareThreshold) {
//     //         randomRank = Rank.Rare;
//     //     } else if (randomNumber < epicThreshold) {
//     //         randomRank = Rank.Epic;
//     //     } else {
//     //         randomRank = Rank.Legendary;
//     //     }

//     //     // Get the minting price for the chosen rarity
//     //     uint256 mintingPrice = getPrice(uint256(randomRank));
//     //     require(msg.value >= mintingPrice, "Insufficient ether sent");

//     //     // Increment the tokenIds counter
//     //     _tokenIds.increment();

//     //     // Mint the NFT with the generated token ID and given URL
//     //     _mint(msg.sender, _tokenIds.current());
//     //     _setTokenURI(_tokenIds.current(), _NFT_url);

//     //     // Store the NFT details in the mapping
//     //     NFTs[_tokenIds.current()] = NFT(
//     //         _tokenIds.current(),
//     //         _NFT_url,
//     //         randomRank
//     //     );
//     // }

//     function editPriceMint(uint256 _rank, uint256 _newPrice) public {
//         require(msg.sender == owner, "Only owner can edit price");
//         price[_rank] = _newPrice;
//     }

//     function getPrice(uint256 _rank) public view returns (uint256) {
//         return price[_rank];
//     }

//     function getAllMyNft() public view returns (uint256[] memory) {
//         uint256[] memory result = new uint256[](_tokenIds.current());
//         uint256 counter = 0;
//         for (uint256 i = 1; i <= _tokenIds.current(); i++) {
//             if (ownerOf(i) == msg.sender) {
//                 result[counter] = i;
//                 counter++;
//             }
//         }
//         return result;
//     }

//     function getNFTURI(uint256 tokenId) public view returns (string memory) {
//         return tokenURI(tokenId);
//     }

//     function getNFTRank(uint256 tokenId) public view returns (Rank) {
//         require(_exists(tokenId), "Token ID does not exist");

//         return NFTs[tokenId].rank;
//     }

//     function transferNFT(address _to, uint256 _tokenId) public {
//         safeTransferFrom(msg.sender, _to, _tokenId);
//     }

//     function _burn(uint256 tokenId) internal override(ERC721URIStorage) {
//         super._burn(tokenId);
//     }

//     function tokenURI(
//         uint256 tokenId
//     ) public view override(ERC721URIStorage) returns (string memory) {
//         return super.tokenURI(tokenId);
//     }

//     function supportsInterface(
//         bytes4 interfaceId
//     ) public view override(ERC721URIStorage) returns (bool) {
//         return super.supportsInterface(interfaceId);
//     }

//     function getAllMintedNFTs() public view returns (NFT[] memory) {
//         NFT[] memory mintedNFTs = new NFT[](_tokenIds.current());

//         for (uint256 i = 1; i <= _tokenIds.current(); i++) {
//             if (_exists(i)) {
//                 mintedNFTs[i - 1] = NFTs[i];
//             }
//         }

//         return mintedNFTs;
//     }
// }

// // function createNFT(
// //     string memory _NFT_url,
// //     Rank _rank
// // ) public returns (uint256) {
// //     _tokenIds.increment();
// //     uint256 newItemId = _tokenIds.current();
// //     _mint(msg.sender, newItemId);
// //     _setTokenURI(newItemId, _NFT_url);
// //     NFTs[newItemId] = NFT(newItemId, _NFT_url, _rank);
// //     return newItemId;
// // }
