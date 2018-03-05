pragma solidity ^0.4.18;
import './oraclizeAPI.sol';

contract FuturesContract is usingOraclize {

  bool public isValid;
  bool public isSigned;

  uint256 public expiryDate;
  uint256 public bettingPairing;

  address public owner;
  address public signer;

  string contractCode;
  string api;

  // Events
  event LogNewOraclizeQuery(string oraclizeLog);

  function FuturesContract(uint256 _expiryDate, uint256 _bettingPairing, string _api) public payable {
    owner = msg.sender;
    isValid = true;

    expiryDate = _expiryDate;
    bettingPairing = _bettingPairing;
    api = _api;
  }

  function signContract() public payable {
    require(msg.sender != owner);

    if (oraclize_getPrice("URL") > this.balance) {
      LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
    }
    else {
      LogNewOraclizeQuery("Retrieving lastest pairing...");

      isSigned = true;
      oraclize_query(scheduled_arrivaltime + expiryDate * 3600, "URL", api);
      // Example json response: {"data":{"base":"ETH","currency":"USD","amount":"848.22"}}
    }
  }

  function __callback(bytes32 _queryID, string _result) public {
    // Callback called by oraclize api contract
    require(msg.sender == oraclize_cbAddress());

    uint256 resultPairing = parseInt(_result);
    if (resultPairing > bettingPairing) {
    }
    else {
    }
  }

}
