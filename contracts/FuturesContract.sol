pragma solidity ^0.4.18;

contract FuturesContract {

  address public ownerAddress;
  bool public isValid;

  function FuturesContract(uint256 _expiryTimeStampUTC) public payable {
    ownerAddress = msg.sender;
  }

}
