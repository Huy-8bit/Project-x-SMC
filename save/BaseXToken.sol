// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BaseXToken is ERC20("BaseX Token", "HRT"), Ownable {
    uint256 private cap = 100_000_000_000 * 10 ** 18;

    constructor() {
        _mint(msg.sender, cap);
        transferOwnership(msg.sender);
    }

    function mint(address _to, uint256 _amount) public onlyOwner {
        require(
            ERC20.totalSupply() + _amount <= cap,
            "BaseXToken: cap exceeded"
        );
        _mint(_to, _amount);
    }

    function transfer(
        address _to,
        uint256 _amount
    ) public override returns (bool) {
        return super.transfer(_to, _amount);
    }
}
