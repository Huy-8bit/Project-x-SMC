// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BasicNFT is ERC721URIStorage, Ownable {
    constructor() ERC721("Basic NFT", "BNFT") {}

    function mintNFT(
        address to,
        uint256 tokenId,
        string memory tokenURI
    ) external onlyOwner {
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

    function transferNFT(address to, uint256 tokenId) external {
        require(
            ownerOf(tokenId) == msg.sender,
            "You are not the owner of this NFT"
        );
        safeTransferFrom(msg.sender, to, tokenId);
    }

    function transferOwnershipNFT(address to) external onlyOwner {
        transferOwnership(to);
    }
}
