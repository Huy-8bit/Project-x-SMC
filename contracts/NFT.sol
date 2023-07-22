// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "hardhat/console.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// contract HeroNFT is ERC721URIStorage {
//     using Counters for Counters.Counter;
//     Counters.Counter private _tokenIds;
//     Counters.Counter private _itemsSold;
//     address public owner;
//     string public NFT_url;

//     constructor() ERC721("Hero NFT", "HR") {
//         owner = msg.sender;
//     }

//     function createNFT(string memory _NFT_url) public returns (uint256) {
//         _tokenIds.increment();
//         uint256 newItemId = _tokenIds.current();

//         _mint(msg.sender, newItemId);
//         _setTokenURI(newItemId, _NFT_url);

//         return newItemId;
//     }

//     function mintNFTWithId(uint256 _tokenId, string memory _NFT_url) public {
//         require(!_exists(_tokenId), "Token ID already exists");

//         _mint(msg.sender, _tokenId);
//         _setTokenURI(_tokenId, _NFT_url);
//     }

//     function approveNFT(uint256 _tokenId) public {
//         approve(owner, _tokenId);
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

//     function transferNFT(address _to, uint256 _tokenId) public {
//         safeTransferFrom(msg.sender, _to, _tokenId);
//     }
// }

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HeroNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;
    address public owner;
    string public NFT_url;

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

    mapping(uint256 => NFT) public NFTs;

    constructor() ERC721("Hero NFT", "HR") {
        owner = msg.sender;
    }

    function createNFT(
        string memory _NFT_url,
        Rank _rank
    ) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, _NFT_url);

        NFTs[newItemId] = NFT(newItemId, _NFT_url, _rank);

        return newItemId;
    }

    function mintNFTWithId(
        uint256 _tokenId,
        string memory _NFT_url,
        Rank _rank
    ) public {
        require(!_exists(_tokenId), "Token ID already exists");

        _mint(msg.sender, _tokenId);
        _setTokenURI(_tokenId, _NFT_url);

        NFTs[_tokenId] = NFT(_tokenId, _NFT_url, _rank);
    }

    function approveNFT(uint256 _tokenId) public {
        approve(owner, _tokenId);
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
}
