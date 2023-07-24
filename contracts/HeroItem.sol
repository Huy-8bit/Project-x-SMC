// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HeroItem is ERC1155, Ownable {
    mapping(uint256 => string) private _tokenURIs;

    string private _baseURI;

    constructor(string memory uri) ERC1155(uri) {
        _baseURI = uri;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        return string(abi.encodePacked(_baseURI, _tokenURIs[tokenId]));
    }

    function mint(
        address account,
        uint256 tokenId,
        uint256 amount,
        string memory tokenURI
    ) public onlyOwner {
        _mint(account, tokenId, amount, "");
        _tokenURIs[tokenId] = tokenURI;
    }

    function burn(
        address account,
        uint256 tokenId,
        uint256 amount
    ) public onlyOwner {
        _burn(account, tokenId, amount);
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(_baseURI, _tokenURIs[tokenId]));
    }

    function totalSupply(uint256 tokenId) public view returns (uint256) {
        return balanceOf(owner(), tokenId);
    }
}
