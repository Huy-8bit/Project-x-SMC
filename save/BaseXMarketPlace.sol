// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BaseXNFT.sol";
import "./BaseXToken.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./BaseXMarketPlace.sol";

contract BaseXMarketPlace {
    address public owner;
    uint256 public totalNFTs;
    uint256 public totalItems;
    BaseXNFT public baseXNFT;
    BaseXToken public baseXToken;

    // NFT ERC721
    struct ListedNFTToken {
        uint256 tokenId;
        address payable owner;
        address payable seller;
        uint256 price;
        bool currentlyListed;
    }
    event TokenListedSuccess(
        uint256 indexed tokenId,
        address owner,
        address seller,
        uint256 price,
        bool currentlyListed
    );
    mapping(uint256 => ListedNFTToken) public idToListedToken;

    constructor(address _baseXTokenAddress, address _baseXNFTAddress) {
        owner = msg.sender;
        baseXNFT = BaseXNFT(_baseXNFTAddress);
        baseXToken = BaseXToken(_baseXTokenAddress);
    }

    function get_owner() public view returns (address) {
        return owner;
    }

    function get_baseXNFT() public view returns (address) {
        return address(baseXNFT);
    }

    function get_baseXToken() public view returns (address) {
        return address(baseXToken);
    }

    function getListedTokenForId(
        uint256 _tokenId
    ) public view returns (ListedNFTToken memory) {
        return idToListedToken[_tokenId];
    }

    function approveNft(uint256 _tokenId) public {
        baseXNFT.approve(owner, _tokenId);
    }

    function ListedNFT(
        uint256 _tokenId,
        uint256 _price
    ) public returns (ListedNFTToken memory) {
        // require(msg.sender == owner, "You are not the owner of this contract");
        // uint256 tokenId = baseXNFT.createNFT(_NFT_url);
        totalNFTs++;
        // baseXNFT.approveNFT(_tokenId);
        idToListedToken[_tokenId] = ListedNFTToken(
            _tokenId,
            payable(msg.sender),
            payable(msg.sender),
            _price,
            true
        );
        emit TokenListedSuccess(_tokenId, msg.sender, msg.sender, _price, true);
        return idToListedToken[_tokenId];
    }

    function buyNft(uint256 _tokenId) public payable {
        ListedNFTToken memory listedToken = idToListedToken[_tokenId];
        address seller = listedToken.seller;
        uint256 price = listedToken.price;
        require(
            baseXToken.transferFrom(msg.sender, seller, price),
            "Token transfer failed"
        );
        baseXNFT.transferFrom(seller, msg.sender, _tokenId);
        listedToken.owner = payable(msg.sender);
        listedToken.seller = payable(msg.sender);
        listedToken.currentlyListed = false;
        idToListedToken[_tokenId] = listedToken;
    }

    function removeFromMarket(uint256 _tokenId) public {
        ListedNFTToken storage listedToken = idToListedToken[_tokenId];

        require(
            listedToken.seller == msg.sender,
            "You are not the seller of this token"
        );

        delete idToListedToken[_tokenId];

        listedToken.currentlyListed = false;
        idToListedToken[_tokenId] = listedToken;
    }

    function getAllListedTokens()
        public
        view
        returns (ListedNFTToken[] memory)
    {
        ListedNFTToken[] memory listedNFTTokens = new ListedNFTToken[](
            totalNFTs
        );
        uint256 counter = 0;
        for (uint256 i = 1; i <= totalNFTs; i++) {
            if (idToListedToken[i].currentlyListed) {
                listedNFTTokens[counter] = idToListedToken[i];
                counter++;
            }
        }
        return listedNFTTokens;
    }

    function getMyNFTs() public view returns (ListedNFTToken[] memory) {
        ListedNFTToken[] memory listedTokens = new ListedNFTToken[](totalNFTs);
        uint256 counter = 0;
        for (uint256 i = 1; i <= totalNFTs; i++) {
            if (idToListedToken[i].owner == msg.sender) {
                listedTokens[counter] = idToListedToken[i];
                counter++;
            }
        }
        return listedTokens;
    }

    function getAllNFTs() public view returns (ListedNFTToken[] memory) {
        ListedNFTToken[] memory listedTokens = new ListedNFTToken[](totalNFTs);
        uint256 counter = 0;
        for (uint256 i = 1; i <= totalNFTs; i++) {
            listedTokens[counter] = idToListedToken[i];
            counter++;
        }
        return listedTokens;
    }

    function transctionNft(address _to, uint256 _tokenId) public {
        ListedNFTToken memory listedToken = idToListedToken[_tokenId];
        require(
            listedToken.owner == msg.sender,
            "You are not the owner of this NFT"
        );
        baseXNFT.transferFrom(msg.sender, _to, _tokenId);
        listedToken.owner = payable(_to);
        listedToken.seller = payable(_to);
        idToListedToken[_tokenId] = listedToken;
    }

    function editPriceNft(uint256 _tokenId, uint256 _price) public {
        ListedNFTToken memory listedToken = idToListedToken[_tokenId];
        require(
            listedToken.owner == msg.sender,
            "You are not the owner of this NFT"
        );
        listedToken.price = _price;
        idToListedToken[_tokenId] = listedToken;
    }
}