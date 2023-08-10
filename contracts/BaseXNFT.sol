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

    uint256 public price;

    address private lastAddress;

    uint256 public totalSupply;
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

    mapping(address => uint256[]) private mintedNFTIds;
    mapping(address => uint256) public lastMintTimestamp;
    mapping(uint256 => NFT) public NFTs;

    constructor() ERC721("BaseX NFT", "BX") {
        limitMint = 10;
        lastAddress = msg.sender;
        totalSupply = 0;
        price = 0.0000 ether;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function editLimitMint(uint256 _newLimit) public onlyOwner {
        limitMint = _newLimit;
    }

    function mintNFT(string memory _NFT_url) public payable {
        require(
            balanceOf(msg.sender) < limitMint,
            "You have reached the limit of minting"
        );
        require(msg.value >= price, "Insufficient ether sent");

        uint256 randomNumber = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.difficulty,
                    msg.sender,
                    lastAddress
                )
            )
        );

        uint256 calculates = randomNumber % 100;
        Rank randomRank;

        if (calculates < 60) {
            // it's 60% for common
            randomRank = Rank.Common;
        } else if (calculates < 85) {
            // it's 25% for rare
            randomRank = Rank.Rare;
        } else if (calculates < 95) {
            // it's 10% for epic
            randomRank = Rank.Epic;
        } else {
            randomRank = Rank.Legendary;
        }

        totalSupply += 1;
        if (totalSupply >= 15000) {
            price = 0.0001 ether;
        } else if (totalSupply >= 10000) {
            price = 0.00005 ether;
        } else if (totalSupply >= 5000) {
            price = 0.00002 ether;
        } else {
            price = 0.00000 ether;
        }
        lastAddress = msg.sender;
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _NFT_url);

        NFT memory newNFT = NFT(newTokenId, randomRank);

        mintedNFTIds[msg.sender].push(newTokenId);
        NFTs[newTokenId] = newNFT;
        lastMintTimestamp[msg.sender] = block.timestamp;

        emit NFTMinted(
            newTokenId,
            uint256(randomRank),
            msg.sender,
            block.timestamp
        );
    }

    function getLastAdress() public view onlyOwner returns (address) {
        return lastAddress;
    }

    function editPriceMint(uint256 _newPrice) public onlyOwner {
        price = _newPrice;
    }

    function getPrice() public view returns (uint256) {
        return price;
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

    function getMintedNFTs(
        address user
    ) public view returns (uint256[] memory) {
        return mintedNFTIds[user];
    }

    function getAllMyNFT() public view returns (NFT[] memory) {
        uint256[] memory myNFTs = mintedNFTIds[msg.sender];
        NFT[] memory myNFTsInfo = new NFT[](myNFTs.length);
        for (uint256 i = 0; i < myNFTs.length; i++) {
            myNFTsInfo[i] = NFTs[myNFTs[i]];
        }
        return myNFTsInfo;
    }

    function getPoint(address user) public view returns (uint256) {
        uint256[] memory myNFTs = mintedNFTIds[user];
        uint256 point = 0;
        for (uint256 i = 0; i < myNFTs.length; i++) {
            if (NFTs[myNFTs[i]].rank == Rank.Common) {
                point += 1;
            } else if (NFTs[myNFTs[i]].rank == Rank.Rare) {
                point += 5;
            } else if (NFTs[myNFTs[i]].rank == Rank.Epic) {
                point += 15;
            } else if (NFTs[myNFTs[i]].rank == Rank.Legendary) {
                point += 50;
            }
        }
        return point;
    }
}
