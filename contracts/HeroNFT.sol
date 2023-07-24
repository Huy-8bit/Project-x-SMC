// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./HeroMarketPlace.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract HeroNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;
    address public owner;
    string public NFT_url;
    // price for each rank
    uint256[4] public price = [0.1 ether, 0.2 ether, 0.3 ether, 0.4 ether];
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

    function mintNFTWithId(
        uint256 _tokenId,
        string memory _NFT_url,
        Rank _rank
    ) public payable {
        require(!_exists(_tokenId), "Token ID already exists");
        require(
            balanceOf(msg.sender) < 2 || msg.sender == owner,
            "You can only own 2 NFTs at most"
        );
        require(
            _rank == Rank.Common ||
                _rank == Rank.Rare ||
                _rank == Rank.Epic ||
                _rank == Rank.Legendary,
            "Invalid rank"
        );
        require(
            address(msg.sender).balance >= 0.5 ether,
            "Insufficient payment"
        ); // Require at least 0.5 ETH to mint
        require(
            // transfer 0.5 ETH to owner
            payable(owner).send(0.5 ether),
            "Transfer failed"
        );

        _tokenIds.increment();

        _mint(msg.sender, _tokenId);
        _setTokenURI(_tokenId, _NFT_url);

        NFTs[_tokenId] = NFT(_tokenId, _NFT_url, _rank);
    }

    function checkValue() public view returns (uint256) {
        return address(this).balance;
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

// function createNFT(
//     string memory _NFT_url,
//     Rank _rank
// ) public returns (uint256) {
//     _tokenIds.increment();
//     uint256 newItemId = _tokenIds.current();
//     _mint(msg.sender, newItemId);
//     _setTokenURI(newItemId, _NFT_url);
//     NFTs[newItemId] = NFT(newItemId, _NFT_url, _rank);
//     return newItemId;
// }
