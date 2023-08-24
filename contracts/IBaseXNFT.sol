// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// contract BaseXNFT is ERC721URIStorage, Ownable {
//     using Counters for Counters.Counter;

//     Counters.Counter private _tokenIds;

//     string public NFT_url;

//     uint256 public limitMint;

//     uint256 public price;

//     address private lastAddress;

//     uint256 public totalSupply;

//     uint256 public limitTotalMinted;
//     enum Rank {
//         Common,
//         Rare,
//         Epic,
//         Legendary
//     }

//     struct NFT {
//         uint256 tokenId;
//         Rank rank;
//     }

//     event NFTMinted(uint256 indexed tokenId, uint256 rank, uint256 time_minted);

//     struct NFTUrls {
//         string urlCommon;
//         string urlRare;
//         string urlEpic;
//         string urlLegendary;
//     }

//     NFTUrls private nftUrls =
//         NFTUrls({
//             urlCommon: "https://ipfs.io/ipfs/QmcaDRKb5cM5CN6GDMBYw4m3DtUuHVZ6fSeCqiV9YMqZww?filename=NFT0.json",
//             urlRare: "https://ipfs.io/ipfs/QmcJ1FADWWFWupH83KPVmc1qhNAmiKmHbM5g5TjvtRg9e5?filename=NFT1.json",
//             urlEpic: "https://ipfs.io/ipfs/QmTgqMd7MYNLNGQyhszEPgwcaiumY54k99tZNabFdqYiVf?filename=NFT2.json",
//             urlLegendary: "https://ipfs.io/ipfs/QmRQmLmoxC8aCoDUkSqUTKusG3t2p5MdtU1qjGAG9ssL5u?filename=NFT3.json"
//         });

//     bool private priceChanged = false;

//     // mapping(address => uint256[]) private mintedNFTIds;

//     address[] private mintingAddresses;

//     mapping(address => bool) private freeMintAllowed;

//     // mapping(address => uint256) public lastMintTimestamp;

//     mapping(uint256 => NFT) public NFTs;

//     uint256[] private Rarity;
//     // event RarityChanged(uint256[] newRarity);

//     bool private withdrawFlag;

//     address private ownerWithDraw;

//     uint256 private totalLimitMint;

//     bool private mintChanged;

//     uint256 private limitMintWhilteList;

//     constructor(address _ownerWithDraw) ERC721("BaseX Spaceship", "BX") {
//         limitMint = 10;
//         lastAddress = msg.sender;
//         totalSupply = 0;
//         price = 0.0000 ether;
//         Rarity.push(60);
//         Rarity.push(25);
//         Rarity.push(10);
//         Rarity.push(5);
//         withdrawFlag = false;
//         ownerWithDraw = _ownerWithDraw;
//         totalLimitMint = 100;
//         mintChanged = false;
//         limitTotalMinted = 20000;
//         limitMintWhilteList = 20;
//     }

//     function editLimitMint(uint256 _newLimit) public onlyOwner {
//         limitMint = _newLimit;
//     }

//     function editPriceMint(uint256 _newPrice) public onlyOwner {
//         price = _newPrice;
//         priceChanged = true;
//     }

//     function changeflagPriceChanged(bool _flag) public onlyOwner {
//         priceChanged = _flag;
//     }

//     function addFreeMintAddress(address _address) public onlyOwner {
//         freeMintAllowed[_address] = true;
//     }

//     function removeFreeMintAddress(address _address) public onlyOwner {
//         freeMintAllowed[_address] = false;
//     }

//     function mintChangedFlag(bool _flag) public onlyOwner {
//         mintChanged = _flag;
//     }

//     function mintNFT(address _ownerNFT) internal {
//         uint256 randomNumber = uint256(
//             keccak256(
//                 abi.encodePacked(
//                     block.number,
//                     block.timestamp,
//                     block.difficulty,
//                     msg.sender,
//                     lastAddress
//                 )
//             )
//         );

//         uint256 calculates = randomNumber % 100;
//         Rank randomRank;

//         if (calculates < Rarity[0] && calculates >= 0) {
//             // it's 60% for common
//             randomRank = Rank.Common;
//         } else if (
//             calculates < Rarity[0] + Rarity[1] && calculates >= Rarity[0]
//         ) {
//             // it's 25% for rare
//             randomRank = Rank.Rare;
//         } else if (
//             calculates < Rarity[0] + Rarity[1] + Rarity[2] &&
//             calculates >= Rarity[0] + Rarity[1]
//         ) {
//             // it's 10% for epic
//             randomRank = Rank.Epic;
//         } else {
//             randomRank = Rank.Legendary;
//         }

//         totalSupply += 1;
//         if (priceChanged == false) {
//             if (totalSupply + limitMintWhilteList >= 40) {
//                 price = 0.00002 ether;
//             } else if (totalSupply + limitMintWhilteList >= 10) {
//                 price = 0.00001 ether;
//             } else {
//                 price = 0.000000 ether;
//             }
//         }

//         lastAddress = msg.sender;
//         _tokenIds.increment();
//         uint256 newTokenId = _tokenIds.current();
//         _mint(msg.sender, newTokenId);
//         string memory _NFT_url = "";
//         if (randomRank == Rank.Common) {
//             _NFT_url = nftUrls.urlCommon;
//         } else if (randomRank == Rank.Rare) {
//             _NFT_url = nftUrls.urlRare;
//         } else if (randomRank == Rank.Epic) {
//             _NFT_url = nftUrls.urlEpic;
//         } else {
//             _NFT_url = nftUrls.urlLegendary;
//         }
//         _setTokenURI(newTokenId, _NFT_url);

//         NFT memory newNFT = NFT(newTokenId, randomRank);

//         NFTs[newTokenId] = newNFT;

//         // check msg.sender is in mintingAddresses
//         if (mintingAddresses.length == 0) {
//             mintingAddresses.push(_ownerNFT);
//         } else {
//             bool isExist = false;
//             for (uint256 i = 0; i < mintingAddresses.length; i++) {
//                 if (mintingAddresses[i] == _ownerNFT) {
//                     isExist = true;
//                     break;
//                 }
//             }
//             if (!isExist) {
//                 mintingAddresses.push(_ownerNFT);
//             }
//         }

//         emit NFTMinted(newTokenId, uint256(randomRank), block.timestamp);
//     }

//     function mintNFT() public payable {
//         require(
//             totalSupply < limitTotalMinted,
//             "This collection has reached the limit of minting"
//         );

//         if (mintChanged == false) {
//             if (totalSupply >= limitMintWhilteList) {
//                 mintChanged = true;
//             }
//             require(freeMintAllowed[msg.sender], "You are not allowed to mint");
//             require(
//                 totalLimitMint >= totalSupply,
//                 "You have reached the limit of minting"
//             );
//             mintNFT(msg.sender);
//         }

//         if (mintChanged == true) {
//             require(
//                 balanceOf(msg.sender) < limitMint,
//                 "You have reached the limit of minting"
//             );
//             if (!freeMintAllowed[msg.sender]) {
//                 require(msg.value >= price, "Insufficient ether sent");
//             }
//             mintNFT(msg.sender);
//         }
//     }

//     function getLastAdress() public view onlyOwner returns (address) {
//         return lastAddress;
//     }

//     function changeRarity(uint256[] memory _newRarity) public onlyOwner {
//         require(_newRarity.length == 4, "Rarity must have 4 elements");
//         require(
//             _newRarity[0] + _newRarity[1] + _newRarity[2] + _newRarity[3] ==
//                 100,
//             "The sum of rarity must be 100"
//         );

//         Rarity = _newRarity;
//     }

//     function getRarity() public view returns (uint256[] memory) {
//         return Rarity;
//     }

//     function getPrice() public view returns (uint256) {
//         if (freeMintAllowed[msg.sender]) {
//             return 0.0000 ether;
//         }
//         return price;
//     }

//     function getNFTRank(uint256 tokenId) public view returns (Rank) {
//         require(_exists(tokenId), "Token ID does not exist");
//         return NFTs[tokenId].rank;
//     }

//     function transferNFT(address _to, uint256 _tokenId) public {
//         require(
//             ownerOf(_tokenId) == msg.sender,
//             "You are not the owner of this NFT"
//         );
//         safeTransferFrom(msg.sender, _to, _tokenId);
//     }

//     function _burn(uint256 tokenId) internal override(ERC721URIStorage) {
//         super._burn(tokenId);
//     }

//     function supportsInterface(
//         bytes4 interfaceId
//     ) public view override(ERC721URIStorage) returns (bool) {
//         return super.supportsInterface(interfaceId);
//     }

//     function getOwnedNFTs(address user) public view returns (uint256[] memory) {
//         uint256 ownedCount = balanceOf(user);
//         uint256[] memory ownedNFTs = new uint256[](ownedCount);

//         uint256 currentIndex = 0;
//         for (uint256 tokenId = 1; tokenId <= _tokenIds.current(); tokenId++) {
//             if (_exists(tokenId) && ownerOf(tokenId) == user) {
//                 ownedNFTs[currentIndex] = tokenId;
//                 currentIndex++;
//             }
//         }

//         return ownedNFTs;
//     }

//     function getPoint(address _user) public view returns (uint256) {
//         uint256[] memory myNFTs = getOwnedNFTs(_user); // huongiuhuy
//         uint256 point = 0;
//         for (uint256 i = 0; i < myNFTs.length; i++) {
//             if (NFTs[myNFTs[i]].rank == Rank.Common) {
//                 point += 1;
//             } else if (NFTs[myNFTs[i]].rank == Rank.Rare) {
//                 point += 5;
//             } else if (NFTs[myNFTs[i]].rank == Rank.Epic) {
//                 point += 15;
//             } else if (NFTs[myNFTs[i]].rank == Rank.Legendary) {
//                 point += 50;
//             }
//         }
//         return point;
//     }

//     function _sortTopMintingAddresses()
//         internal
//         view
//         returns (address[] memory)
//     {
//         uint256[] memory indices = new uint256[](mintingAddresses.length);

//         for (uint256 i = 0; i < mintingAddresses.length; i++) {
//             indices[i] = i;
//         }

//         for (uint256 i = 0; i < mintingAddresses.length - 1; i++) {
//             for (uint256 j = i + 1; j < mintingAddresses.length; j++) {
//                 if (
//                     getPoint(mintingAddresses[indices[i]]) <
//                     getPoint(mintingAddresses[indices[j]])
//                 ) {
//                     (indices[i], indices[j]) = (indices[j], indices[i]);
//                 }
//             }
//         }

//         address[] memory sortedAddresses = new address[](
//             mintingAddresses.length
//         );

//         for (uint256 i = 0; i < mintingAddresses.length; i++) {
//             sortedAddresses[i] = mintingAddresses[indices[i]];
//         }

//         return sortedAddresses;
//     }

//     function getTopMintNFT(uint256 top) public view returns (address[] memory) {
//         require(top > 0, "Top must be greater than zero");
//         require(
//             top <= mintingAddresses.length,
//             "Top exceeds the number of minting addresses"
//         );

//         address[] memory topAddresses = new address[](top);

//         address[] memory sortedAddresses = _sortTopMintingAddresses();

//         for (uint256 i = 0; i < top; i++) {
//             topAddresses[i] = sortedAddresses[i];
//         }
//         return topAddresses;
//     }

//     function changeWithdrawFlag(bool _flag) external {
//         require(msg.sender == ownerWithDraw, "You are not the owner");
//         withdrawFlag = _flag;
//     }

//     function withdraw() public onlyOwner {
//         require(withdrawFlag == true, "You can not withdraw at this time");
//         uint256 balance = address(this).balance;
//         payable(msg.sender).transfer(balance);
//     }

//     function withdrawRewards(
//         uint256 numberOfWinners,
//         uint256 rewardPercentage
//     ) public onlyOwner {
//         require(
//             numberOfWinners > 0,
//             "Number of winners must be greater than zero"
//         );
//         require(
//             numberOfWinners <= mintingAddresses.length,
//             "Number of winners exceeds the number of minting addresses"
//         );
//         require(
//             rewardPercentage > 0 && rewardPercentage <= 100,
//             "Reward percentage must be between 1 and 100"
//         );

//         address[] memory topAddresses = getTopMintNFT(numberOfWinners);

//         uint256 totalReward = (address(this).balance * rewardPercentage) / 100;

//         for (uint256 i = 0; i < numberOfWinners; i++) {
//             payable(topAddresses[i]).transfer(totalReward / numberOfWinners);
//         }
//     }
// }

// // function getNFTURI(uint256 tokenId) public view returns (string memory) {
// //     return tokenURI(tokenId);
// // }

// // function tokenURI(
// //     uint256 tokenId
// // ) public view override(ERC721URIStorage) returns (string memory) {
// //     return super.tokenURI(tokenId);
// // }

// // function editUrlNFT(string memory _newUrl, uint256 _rank) public onlyOwner {
// //     if (_rank == 0) {
// //         nftUrls.urlCommon = _newUrl;
// //     } else if (_rank == 1) {
// //         nftUrls.urlRare = _newUrl;
// //     } else if (_rank == 2) {
// //         nftUrls.urlEpic = _newUrl;
// //     } else if (_rank == 3) {
// //         nftUrls.urlLegendary = _newUrl;
// //     }
// // }
