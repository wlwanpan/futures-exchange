pragma solidity ^0.4.18;
import './oraclizeAPI.sol';

contract FuturesContract is usingOraclize {

  enum ContractState { Short, Long }

  bool public isValid;
  bool public isSigned;

  uint256 public expiryDate;
  uint256 public bettingPairs;
  uint256 public bettingPrice;
  uint256 public createAt = now;

  address owner;
  address buyer;

  string contractCode;
  string api;

  ContractState ownerPosition;

  // Events
  event LogOraclizeQuery(string oraclizeLog);
  event BeforeTerminateContact(address winner, uint256 price, string status);

  // Function modifiers
  modifier onlyOwner() { require(msg.sender == owner);_; }
  modifier notOwner() { require(msg.sender != owner);_; }

  function FuturesContract(address _owner, uint256 _expiryDate, uint256 _bettingPairs, uint256 _bettingPrice, string _position, string _api) public payable {
    require(_position == 'Short' || _position == 'Long');
    owner = _owner;
    isValid = true;

    expiryDate = _expiryDate;
    bettingPairs = _bettingPairs;
    bettingPrice = _bettingPrice;
    api = _api;

    if (_position == 'Short') { ownerPosition = ContractState.Short; }
    else { ownerPosition = ContractState.Long; }
  }

  function signContract(address _buyer) public payable notOwner {
    if (oraclize_getPrice("URL") > this.balance) {
      LogOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
    }
    else {
      LogOraclizeQuery("Contract has been Signed");

      isSigned = true;
      buyer = _buyer;
      oraclize_query(scheduled_arrivaltime + expiryDate * 3600, "URL", api);
      // Example json response: {"data":{"base":"ETH","currency":"USD","amount":"848.22"}}
    }
  }

  function cancelContract() public onlyOwner {
    teminateContract(buyer, 'Contract has been cancelled');
  }

  function __callback(bytes32 _queryID, string _result) public {
    // Callback called by oraclize api contract
    require(msg.sender == oraclize_cbAddress());

    uint256 resultPairing = parseInt(_result);
    if (resultPairing >= bettingPrice && ownerPosition == ContractState.Long) {
      // Owner Won the bet
      teminateContract(owner, 'Contract terminated. Owner won.');
    }
    else {
      // Owner lost the bet
      teminateContract(buyer, 'Contract terminated. Buyer won.');
    }
  }

  function teminateContract(address _claimer, string _status) private {
    BeforeTerminateContact(_claimer, this.balance, _status);
    selfdestruct(_claimer);
  }

}
