// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./utils/BasicNFT.sol";
import "./libraries/BaseXNFTLibrary.sol";

// build contract baseXNFT with basicNFT is libraries
contract BaseXNFT is BasicNFT {
    using BaseXNFTLibrary for BaseXNFTLibrary.NFTUrls;
    using Counters for Counters.Counter;
    BasicNFT basicNFTContract;
    Counters.Counter private _tokenIds;
    string public NFT_url;

    BaseXNFTLibrary.NFTUrls private nftUrls =
        BaseXNFTLibrary.NFTUrls({
            urlCommon: "https://ipfs.io/ipfs/QmcaDRKb5cM5CN6GDMBYw4m3DtUuHVZ6fSeCqiV9YMqZww?filename=NFT0.json",
            urlRare: "https://ipfs.io/ipfs/QmcJ1FADWWFWupH83KPVmc1qhNAmiKmHbM5g5TjvtRg9e5?filename=NFT1.json",
            urlEpic: "https://ipfs.io/ipfs/QmTgqMd7MYNLNGQyhszEPgwcaiumY54k99tZNabFdqYiVf?filename=NFT2.json",
            urlLegendary: "https://ipfs.io/ipfs/QmRQmLmoxC8aCoDUkSqUTKusG3t2p5MdtU1qjGAG9ssL5u?filename=NFT3.json"
        });

    uint256 public limitMint;

    uint256 public price;

    address private lastAddress;

    uint256 public totalSupply;

    uint256 public limitTotalMinted;

    uint256[] public totalMintWithRank;

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

    event NFTMinted(uint256 indexed tokenId, uint256 rank, uint256 time_minted);

    bool private priceChanged = false;

    // mapping(address => uint256[]) private mintedNFTIds;

    address[] private mintingAddresses;

    mapping(address => bool) private freeMintAllowed;

    // mapping(address => uint256) public lastMintTimestamp;

    mapping(uint256 => BaseXNFTLibrary.NFT) public NFTs;

    uint256[] private Rarity;
    // event RarityChanged(uint256[] newRarity);

    bool private withdrawFlag;

    address private ownerWithDraw;

    uint256 private totalLimitMint;

    bool private mintChanged;

    uint256 private limitMintWhilteList;

    constructor(address _ownerWithDraw, address addressOfBasicNFTContract) {
        limitMint = 10;
        lastAddress = msg.sender;
        totalSupply = 0;
        price = 0.0000 ether;
        Rarity.push(60);
        Rarity.push(25);
        Rarity.push(10);
        Rarity.push(5);
        withdrawFlag = false;
        ownerWithDraw = _ownerWithDraw;
        totalLimitMint = 100;
        mintChanged = false;
        limitTotalMinted = 20000;
        limitMintWhilteList = 20;
        totalMintWithRank = [0, 0, 0, 0];
        basicNFTContract = BasicNFT(addressOfBasicNFTContract);
    }

    function editLimitMint(uint256 _newLimit) public onlyOwner {
        limitMint = _newLimit;
    }

    function editPriceMint(uint256 _newPrice) public onlyOwner {
        price = _newPrice;
        priceChanged = true;
    }

    function changeflagPriceChanged(bool _flag) public onlyOwner {
        priceChanged = _flag;
    }

    function addFreeMintAddress(address _address) public onlyOwner {
        freeMintAllowed[_address] = true;
    }

    function removeFreeMintAddress(address _address) public onlyOwner {
        freeMintAllowed[_address] = false;
    }

    function mintChangedFlag(bool _flag) public onlyOwner {
        mintChanged = _flag;
    }

    function mintNFT(address _ownerNFT) internal {
        BaseXNFTLibrary.NFT memory newNFT = BaseXNFTLibrary.calculateNFTInfo(
            block.number,
            block.timestamp,
            block.difficulty,
            msg.sender,
            lastAddress,
            totalMintWithRank,
            totalSupply
        );

        if (newNFT.rank == BaseXNFTLibrary.Rank.Common) {
            totalMintWithRank[0] += 1;
        } else if (newNFT.rank == BaseXNFTLibrary.Rank.Rare) {
            totalMintWithRank[1] += 1;
        } else if (newNFT.rank == BaseXNFTLibrary.Rank.Epic) {
            totalMintWithRank[2] += 1;
        } else {
            totalMintWithRank[3] += 1;
        }

        totalSupply += 1;
        if (priceChanged == false) {
            price = BaseXNFTLibrary.calculatePrice(
                totalSupply,
                limitMintWhilteList
            );
        }

        lastAddress = _ownerNFT;
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        string memory _NFT_url;
        uint256 randomRank;
        if (newNFT.rank == BaseXNFTLibrary.Rank.Common) {
            _NFT_url = nftUrls.urlCommon;
        } else if (newNFT.rank == BaseXNFTLibrary.Rank.Rare) {
            _NFT_url = nftUrls.urlRare;
        } else if (newNFT.rank == BaseXNFTLibrary.Rank.Epic) {
            _NFT_url = nftUrls.urlEpic;
        } else {
            _NFT_url = nftUrls.urlLegendary;
        }

        basicNFTContract.mintNFT(_ownerNFT, newTokenId, _NFT_url);

        NFTs[newTokenId] = newNFT;

        // check msg.sender is in mintingAddresses
        if (mintingAddresses.length == 0) {
            mintingAddresses.push(_ownerNFT);
        } else {
            bool isExist = false;
            for (uint256 i = 0; i < mintingAddresses.length; i++) {
                if (mintingAddresses[i] == _ownerNFT) {
                    isExist = true;
                    break;
                }
            }
            if (!isExist) {
                mintingAddresses.push(_ownerNFT);
            }
        }

        emit NFTMinted(newTokenId, uint256(randomRank), block.timestamp);
    }

    function mint() public payable {
        require(
            totalSupply < limitTotalMinted,
            "This collection has reached the limit of minting"
        );

        if (mintChanged == false) {
            if (totalSupply >= limitMintWhilteList) {
                mintChanged = true;
            }
            require(freeMintAllowed[msg.sender], "You are not allowed to mint");
            require(
                totalLimitMint >= totalSupply,
                "You have reached the limit of minting"
            );
            mintNFT(msg.sender);
        }

        if (mintChanged == true) {
            require(
                balanceOf(msg.sender) < limitMint,
                "You have reached the limit of minting"
            );
            if (!freeMintAllowed[msg.sender]) {
                require(msg.value >= price, "Insufficient ether sent");
            }
            mintNFT(msg.sender);
        }
    }

    function getLastAdress() public view onlyOwner returns (address) {
        return lastAddress;
    }

    function changeRarity(uint256[] memory _newRarity) public onlyOwner {
        require(_newRarity.length == 4, "Rarity must have 4 elements");
        require(
            _newRarity[0] + _newRarity[1] + _newRarity[2] + _newRarity[3] ==
                100,
            "The sum of rarity must be 100"
        );

        Rarity = _newRarity;
    }

    function getRarity() public view returns (uint256[] memory) {
        return Rarity;
    }

    function getPrice() public view returns (uint256) {
        if (freeMintAllowed[msg.sender]) {
            return 0.0000 ether;
        }
        return price;
    }

    function getNFTRank(
        uint256 tokenId
    ) public view returns (BaseXNFTLibrary.Rank) {
        require(_exists(tokenId), "Token ID does not exist");
        return NFTs[tokenId].rank;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function getOwnedNFTs(address user) public view returns (uint256[] memory) {
        uint256 ownedCount = balanceOf(user);
        uint256[] memory ownedNFTs = new uint256[](ownedCount);

        uint256 currentIndex = 0;
        for (uint256 tokenId = 1; tokenId <= _tokenIds.current(); tokenId++) {
            if (_exists(tokenId) && ownerOf(tokenId) == user) {
                ownedNFTs[currentIndex] = tokenId;
                currentIndex++;
            }
        }

        return ownedNFTs;
    }

    function getAllUsers() public view returns (address[] memory) {
        return mintingAddresses;
    }

    function changeWithdrawFlag(bool _flag) external {
        require(msg.sender == ownerWithDraw, "You are not the owner");
        withdrawFlag = _flag;
    }

    function withdraw() public onlyOwner {
        require(withdrawFlag == true, "You can not withdraw at this time");
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function withdrawRewards(
        uint256 numberOfWinners,
        uint256 rewardPercentage,
        address[] memory topAddresses
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
        uint256 totalReward = (address(this).balance * rewardPercentage) / 100;
        uint256 top10Percentage = (totalReward * 30) / 100;
        uint256 top15Percentage = (totalReward * 25) / 100;
        uint256 top25Percentage = (totalReward * 20) / 100;
        uint256 remainingPercentage = (totalReward * 15) / 100;
        uint256 top10Count = (numberOfWinners * 10) / 100;
        uint256 top15Count = (numberOfWinners * 15) / 100;
        uint256 top25Count = (numberOfWinners * 25) / 100;
        uint256 remainingCount = numberOfWinners -
            top10Count -
            top15Count -
            top25Count;
        for (uint256 i = 0; i < top10Count; i++) {
            payable(topAddresses[i]).transfer(top10Percentage / top10Count);
        }
        for (uint256 i = top10Count; i < top10Count + top15Count; i++) {
            payable(topAddresses[i]).transfer(top15Percentage / top15Count);
        }
        for (
            uint256 i = top10Count + top15Count;
            i < top10Count + top15Count + top25Count;
            i++
        ) {
            payable(topAddresses[i]).transfer(top25Percentage / top25Count);
        }
        for (
            uint256 i = top10Count + top15Count + top25Count;
            i < numberOfWinners;
            i++
        ) {
            payable(topAddresses[i]).transfer(
                remainingPercentage / remainingCount
            );
        }
    }
}

// function getPoint(address _user) public view returns (uint256) {
//         uint256[] memory myNFTs = getOwnedNFTs(_user);
//         uint256 point = 0;
//         for (uint256 i = 0; i < myNFTs.length; i++) {
//             if (NFTs[myNFTs[i]].rank == BaseXNFTLibrary.Rank.Common) {
//                 point += 1;
//             } else if (NFTs[myNFTs[i]].rank == BaseXNFTLibrary.Rank.Rare) {
//                 point += 5;
//             } else if (NFTs[myNFTs[i]].rank == BaseXNFTLibrary.Rank.Epic) {
//                 point += 15;
//             } else if (NFTs[myNFTs[i]].rank == BaseXNFTLibrary.Rank.Legendary) {
//                 point += 50;
//             }
//         }

//         return point;
//     }
