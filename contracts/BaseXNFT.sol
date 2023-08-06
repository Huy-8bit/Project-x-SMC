// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BaseXNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string public NFT_url;
    uint256 public limitMint;

    // price for each rank
    uint256 public price = 0.00055 ether;

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

    event NFTMinted(
        uint256 indexed tokenId,
        uint256 rank,
        address owner_minted,
        uint256 time_minted
    );

    mapping(uint256 => NFT) public NFTs;
    mapping(address => uint256) public lastMintTimestamp;

    constructor() ERC721("BaseX NFT", "BX") {
        limitMint = 2;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function editLimitMint(uint256 _newLimit) public onlyOwner {
        limitMint = _newLimit;
    }

    // function mintNFT(string memory _NFT_url) public payable {
    //     require(
    //         balanceOf(msg.sender) < limitMint,
    //         "You have reached the limit of minting"
    //     );
    //     require(msg.value > 0, "Insufficient ether sent");

    //     // Generate a random number between 0 and 99 (inclusive)
    //     uint256 randomNumber = uint256(
    //         keccak256(
    //             abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
    //         )
    //     ) % 100;

    //     // Define the ranges for each rarity
    //     uint256 commonThreshold = 50; // 0 - 49 (50%)
    //     uint256 rareThreshold = commonThreshold + 30; // 50 - 79 (30%)
    //     uint256 epicThreshold = rareThreshold + 15; // 80 - 94 (15%)
    //     uint256 legendaryThreshold = epicThreshold + 5; // 95 - 99 (5%)

    //     Rank randomRank;

    //     // Determine the rarity based on the random number generated
    //     if (randomNumber < commonThreshold) {
    //         randomRank = Rank.Common;
    //     } else if (randomNumber < rareThreshold) {
    //         randomRank = Rank.Rare;
    //     } else if (randomNumber < epicThreshold) {
    //         randomRank = Rank.Epic;
    //     } else {
    //         randomRank = Rank.Legendary;
    //     }

    //     require(msg.value >= price, "Insufficient ether sent");

    //     _tokenIds.increment();
    //     uint256 newTokenId = _tokenIds.current();
    //     _mint(msg.sender, newTokenId);
    //     _setTokenURI(newTokenId, _NFT_url);

    //     NFT memory newNFT = NFT(newTokenId, randomRank);
    //     NFTs[newTokenId] = newNFT;

    //     lastMintTimestamp[msg.sender] = block.timestamp;

    //     emit NFTMinted(
    //         newTokenId,
    //         uint256(randomRank),
    //         msg.sender,
    //         block.timestamp
    //     );
    // }

    function mintNFT(string memory _NFT_url) public payable {
        require(
            balanceOf(msg.sender) < limitMint,
            "You have reached the limit of minting"
        );
        require(msg.value >= price, "Insufficient ether sent");

        // Generate a random number between 0 and 2^256-1
        uint256 randomNumber = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
            )
        );

        // Define the ranges for each rarity
        uint256 commonThreshold = uint256(
            keccak256(abi.encodePacked(randomNumber, "Common"))
        ) % 100;
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

        _tokenIds.increment();
        _mint(msg.sender, randomNumber);
        _setTokenURI(randomNumber, _NFT_url);

        NFT memory newNFT = NFT(randomNumber, randomRank);
        NFTs[randomNumber] = newNFT;

        lastMintTimestamp[msg.sender] = block.timestamp;

        emit NFTMinted(
            randomNumber,
            uint256(randomRank),
            msg.sender,
            block.timestamp
        );
    }

    function editPriceMint(uint256 _newPrice) public onlyOwner {
        price = _newPrice;
    }

    function getPrice() public view returns (uint256) {
        return price;
    }

    function getAllMyNft() public view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](balanceOf(msg.sender));
        uint256 counter = 0;
        for (uint256 i = 1; i <= _tokenIds.current(); i++) {
            if (_exists(i) && ownerOf(i) == msg.sender) {
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
        require(
            ownerOf(_tokenId) == msg.sender,
            "You are not the owner of this NFT"
        );
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
        NFT[] memory result = new NFT[](_tokenIds.current());
        for (uint256 i = 1; i <= _tokenIds.current(); i++) {
            if (_exists(i)) {
                result[i - 1] = NFT(i, NFTs[i].rank);
            }
        }
        return result;
    }
}
