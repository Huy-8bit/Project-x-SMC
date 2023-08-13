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

    struct NFTUrls {
        string urlCommon;
        string urlRare;
        string urlEpic;
        string urlLegendary;
    }

    NFTUrls private nftUrls =
        NFTUrls({
            urlCommon: "https://red-flying-lynx-578.mypinata.cloud/ipfs/QmZqeKmGoquMG5nFCb9q82WHR4F1Rd3WeMbW1QEPJifHsc/nft.json",
            urlRare: "https://red-flying-lynx-578.mypinata.cloud/ipfs/QmZqeKmGoquMG5nFCb9q82WHR4F1Rd3WeMbW1QEPJifHsc/nft.json",
            urlEpic: "https://red-flying-lynx-578.mypinata.cloud/ipfs/QmZqeKmGoquMG5nFCb9q82WHR4F1Rd3WeMbW1QEPJifHsc/nft.json",
            urlLegendary: "https://red-flying-lynx-578.mypinata.cloud/ipfs/QmZqeKmGoquMG5nFCb9q82WHR4F1Rd3WeMbW1QEPJifHsc/nft.json"
        });
    bool private priceChanged = false;

    mapping(address => uint256[]) private mintedNFTIds;

    address[] private mintingAddresses;

    mapping(address => uint256) public lastMintTimestamp;

    mapping(uint256 => NFT) public NFTs;

    constructor() ERC721("BaseX NFT", "BX") {
        limitMint = 100;
        lastAddress = msg.sender;
        totalSupply = 0;
        price = 0.0000 ether;
    }

    function editLimitMint(uint256 _newLimit) public onlyOwner {
        limitMint = _newLimit;
    }

    function editPriceMint(uint256 _newPrice) public onlyOwner {
        price = _newPrice;
        priceChanged = true;
    }

    function editUrlNFT(string memory _newUrl, uint256 _rank) public onlyOwner {
        if (_rank == 0) {
            nftUrls.urlCommon = _newUrl;
        } else if (_rank == 1) {
            nftUrls.urlRare = _newUrl;
        } else if (_rank == 2) {
            nftUrls.urlEpic = _newUrl;
        } else if (_rank == 3) {
            nftUrls.urlLegendary = _newUrl;
        }
    }

    function mintNFT() public payable {
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
        if (priceChanged == false) {
            if (totalSupply >= 15000) {
                price = 0.0001 ether;
            } else if (totalSupply >= 10000) {
                price = 0.00005 ether;
            } else if (totalSupply >= 5000) {
                price = 0.00002 ether;
            } else {
                price = 0.00000 ether;
            }
        }
        lastAddress = msg.sender;
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(msg.sender, newTokenId);
        string memory _NFT_url = "";
        if (randomRank == Rank.Common) {
            _NFT_url = nftUrls.urlCommon;
        } else if (randomRank == Rank.Rare) {
            _NFT_url = nftUrls.urlRare;
        } else if (randomRank == Rank.Epic) {
            _NFT_url = nftUrls.urlEpic;
        } else {
            _NFT_url = nftUrls.urlLegendary;
        }
        _setTokenURI(newTokenId, _NFT_url);

        NFT memory newNFT = NFT(newTokenId, randomRank);

        mintedNFTIds[msg.sender].push(newTokenId);
        NFTs[newTokenId] = newNFT;
        lastMintTimestamp[msg.sender] = block.timestamp;
        // mintingAddresses.push(msg.sender);

        // check msg.sender is in mintingAddresses
        if (mintingAddresses.length == 0) {
            mintingAddresses.push(msg.sender);
        } else {
            bool isExist = false;
            for (uint256 i = 0; i < mintingAddresses.length; i++) {
                if (mintingAddresses[i] == msg.sender) {
                    isExist = true;
                    break;
                }
            }
            if (!isExist) {
                mintingAddresses.push(msg.sender);
            }
        }

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

    function changePriceChanged() public onlyOwner {
        priceChanged = false;
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

    function getTopMintNFT(uint256 top) public view returns (address[] memory) {
        require(top > 0, "Top must be greater than zero");
        require(
            top <= mintingAddresses.length,
            "Top exceeds the number of minting addresses"
        );

        address[] memory topAddresses = new address[](top);

        address[] memory sortedAddresses = _sortTopMintingAddresses();

        for (uint256 i = 0; i < top; i++) {
            topAddresses[i] = sortedAddresses[i];
        }
        return topAddresses;
    }

    function _sortTopMintingAddresses()
        internal
        view
        returns (address[] memory)
    {
        uint256[] memory indices = new uint256[](mintingAddresses.length);

        for (uint256 i = 0; i < mintingAddresses.length; i++) {
            indices[i] = i;
        }

        for (uint256 i = 0; i < mintingAddresses.length - 1; i++) {
            for (uint256 j = i + 1; j < mintingAddresses.length; j++) {
                if (
                    getPoint(mintingAddresses[indices[i]]) <
                    getPoint(mintingAddresses[indices[j]])
                ) {
                    (indices[i], indices[j]) = (indices[j], indices[i]);
                }
            }
        }

        address[] memory sortedAddresses = new address[](
            mintingAddresses.length
        );

        for (uint256 i = 0; i < mintingAddresses.length; i++) {
            sortedAddresses[i] = mintingAddresses[indices[i]];
        }

        return sortedAddresses;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function withdrawRewards(
        uint256 numberOfWinners,
        uint256 rewardPercentage
    ) public onlyOwner {
        require(
            numberOfWinners > 0,
            "Number of winners must be greater than zero"
        );
        require(
            numberOfWinners <= mintingAddresses.length,
            "Number of winners exceeds the number of minting addresses"
        );
        require(
            rewardPercentage > 0 && rewardPercentage <= 100,
            "Reward percentage must be between 1 and 100"
        );

        address[] memory topAddresses = getTopMintNFT(numberOfWinners);

        uint256 totalReward = (address(this).balance * rewardPercentage) / 100;

        for (uint256 i = 0; i < numberOfWinners; i++) {
            payable(topAddresses[i]).transfer(totalReward / numberOfWinners);
        }
        withdraw();
    }
}
