// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HeroItem is ERC1155, Ownable {
    // Mảng lưu trữ thông tin của từng token (bạn có thể thay bằng struct nếu cần lưu trữ nhiều thông tin hơn)
    mapping(uint256 => string) private _tokenURIs;

    // Khai báo URI base cho các token
    string private _baseURI;

    constructor(string memory uri) ERC1155(uri) {
        _baseURI = uri;
    }

    // Hàm để lấy URI của một token cụ thể (ghi đè lên hàm trong contract cha)
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        return string(abi.encodePacked(_baseURI, _tokenURIs[tokenId]));
    }

    // Hàm để tạo ra mới một loại token
    function mint(
        address account,
        uint256 tokenId,
        uint256 amount,
        string memory tokenURI
    ) public onlyOwner {
        _mint(account, tokenId, amount, "");
        _tokenURIs[tokenId] = tokenURI;
    }

    // Hàm để trả lại token từ một địa chỉ về smart contract (chủ sở hữu có thể gọi)
    function burn(
        address account,
        uint256 tokenId,
        uint256 amount
    ) public onlyOwner {
        _burn(account, tokenId, amount);
    }

    // Override hàm của ERC1155 để giúp trả về URI của một token cụ thể
    function uri(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(_baseURI, _tokenURIs[tokenId]));
    }

    // Override hàm của ERC1155 để trả về số lượng các loại token đang tồn tại
    function totalSupply(uint256 tokenId) public view returns (uint256) {
        return balanceOf(owner(), tokenId);
    }
}
