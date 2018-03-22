pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract ColorsERC721 is ERC721Token, Ownable{
  string constant public NAME = "COLORS";
  string constant public SYMBOL = "HEX";

  uint256 constant public PRICE = .001 ether;

  mapping(uint256 => uint256) tokenToPriceMap;

  function ColorsERC721() public{

  }

  function name() public pure returns(string){
    return NAME;
  }

  function symbol() public pure returns(string){
    return SYMBOL;
  }

  function mint(uint256 _tokenId) public payable {
    require(msg.value >= PRICE);
    _mint(msg.sender,_tokenId);
    tokenToPriceMap[_tokenId] = PRICE;

    uint priceExcess = msg.value - PRICE;
    msg.sender.transfer(priceExcess);
  }

  function claim(uint _tokenId) public payable onlyMintedToken(_tokenId){
    uint askingPrice= tokenToPriceMap[_tokenId];
    require(msg.value >= askingPrice);

    clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
    tokenToPriceMap[_tokenId] = askingPrice;
  }

  modifier onlyMintedToken(uint _tokenId){
    require(tokenToPriceMap[_tokenId] != 0);
    _;
  }

}
