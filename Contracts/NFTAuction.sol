// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";



contract NFTMarketplace{

    address immutable public owner;
    uint public idForAuction;

    error notEnoughError(uint, string);
    mapping(uint => ItemforAuction) public idToItemForAuction; /*this mapping holds the ItemforAuction object*/


    event NFTAuctionStart(uint _startingPrice, uint indexed _tokenId, uint _deadLine);
    event NFTAuctionCancel(uint indexed _itemForAuctionId);
    event bidPrice(uint _itemForAuctionId, uint _price); 
    event FinisNFtAuction(uint indexed _itemForAuctionId);


    /*constructor sets the owner of contrat
    !be careful the contract owner cannot be changed afterwards.*/
    constructor() {
        owner = msg.sender;
    }

    /*this struct holds the information of NFT*/
    struct ItemforAuction{
        address contractAddress;
        address sellerAddress;
        address buyerAddress;
        uint startingPrice;
        uint highestPrice;
        uint tokenId;
        uint deadline;
        bool state;
    }

    /*this function starts the Auction. 
    and transfers NFT to the contract*/
    function startNFTAuction(address _nftContractAddress, uint _startingPrice, uint _tokenId, uint _deadline) public {

        ERC721 NFT = ERC721(_nftContractAddress);
        require(msg.sender == NFT.ownerOf(_tokenId), "You are not owner of this NFT");
        NFT.transferFrom(msg.sender, address(this), _tokenId);
        require(address(this) == NFT.ownerOf(_tokenId));
        idToItemForAuction[idForAuction] = ItemforAuction(_nftContractAddress, msg.sender, msg.sender , _startingPrice, 0, _tokenId, (block.timestamp + _deadline * 1 days), false);
        idForAuction += 1;
        emit NFTAuctionStart(_startingPrice,_tokenId,_deadline);

    }


    /*this function cancels the auction but the NFT shoundn't have any offer*/
    function cancelNFTAuction(uint _id) idCheck(_id) public{

        ItemforAuction memory info = idToItemForAuction[_id];
        ERC721 NFT = ERC721(info.contractAddress);
        require(info.state == false, "This NFT is already selled");
        require(info.sellerAddress == msg.sender, "You are not owner of this NFT");
        require(info.highestPrice < 0, "This auction is not cancel"); 
        NFT.transferFrom(address(this), msg.sender, info.tokenId);
        idToItemForAuction[_id] = ItemforAuction(address(0), address(0), address(0), 0 , 0 ,0 ,0, true);
        emit NFTAuctionCancel(_id);
    }


    /*this function gets offer if the offer is more than the highest price*/
    function bidPriceToNFT(uint _id) idCheck(_id) public payable {
        ItemforAuction storage info = idToItemForAuction[_id];

        require(info.sellerAddress != msg.sender, "You can not price to this NFT. You are owner of this NFT!");
        require(info.state == false, "This auction is over");
        require(block.timestamp < info.deadline, "This auction is over");
        require(msg.value >= info.startingPrice);
        

        uint moreThenPercentTen = ((info.highestPrice * 100) + (info.highestPrice * 5)); //En az %5 arttırabiliriz.
        assert(moreThenPercentTen < 2**256-1);
        assert(msg.value < 2**256-1);

        if((msg.value * 100) > moreThenPercentTen){
            payable(info.buyerAddress).transfer(info.highestPrice);
            info.highestPrice = msg.value;
            info.buyerAddress = msg.sender;
            emit bidPrice(_id, info.highestPrice);
        }else{
            revert notEnoughError(msg.value, "This price is not enough, You must give at least 5% more value. ");
        }

    }


    /*this function ends the auction but the deadline must have passed */
    function finishNFTAuction(uint _id) idCheck(_id) public {

        ItemforAuction storage info = idToItemForAuction[_id];

        require(msg.sender == info.buyerAddress, "You are not owner of NFT"); //Alıcı adresin açık arttırmayı bitirmesini istiyoruz.
        require(info.deadline < block.timestamp, "This auction is not over");
        require(info.state == false);

        ERC721 NFT = ERC721(info.contractAddress);
        NFT.transferFrom(address(this), info.buyerAddress, info.tokenId);
        uint price = info.highestPrice * 90 / 100;

        payable(info.sellerAddress).transfer(price);
        payable(owner).transfer(info.highestPrice - price);
        info.state = true;

        emit FinisNFtAuction(_id);
    }


    modifier idCheck(uint _id){
        require(_id < idForAuction);
        _;
    }
}
