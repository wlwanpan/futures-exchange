pragma solidity ^0.4.18;
import './FuturesContract.sol';
import './oraclizeAPI_0.5.sol';

contract MarketPlace is usingOraclize {

  string constant coinbaseAPI = "https://api.coinbase.com/v2/prices/ETH-USD/buy";
  string public ETHUSD;
  uint256 constant timeStampInterval = 3*3600;

  struct User {
    bool exist;
    string name;
    uint256[] futuresContractID;
    bytes32 passwordHash;
  }

  address[] userAddresses;
  uint256[] signedFuturesContactIds;
  uint256[] unsignedFuturesContactIds;

  mapping(address => User) users;
  mapping(uint256 => FuturesContract) signedFuturesContracts;
  mapping(uint256 => FuturesContract) unsignedFuturesContracts;

  event ETHParingUpdateLog(bytes32 queryID, uint256 timestamp, string ETHPairing);
  event LogNewOraclizeQuery(string oraclizeLog);

  function MarketPlace() public {

    // Triggers recursive callback for ETH-USD pairing prices
    updateETHPairing();
  }

  function __callback(bytes32 _queryID, string _result) public {
    // Callback called by oraclize api contract
    require(msg.sender != oraclize_cbAddress());

    ETHParingUpdateLog(_queryID, now, _result);
    updateETHPairing();
  }

  function updateETHPairing() private {
    if (oraclize_getPrice("URL") > this.balance) {
      LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
    }
    else {
      LogNewOraclizeQuery("API call sent, as soon as the lastest price has been updated the contract will be destroyed");

      oraclize_query(timeStampInterval, "URL", coinbaseAPI);
      // Example json response: {"data":{"base":"ETH","currency":"USD","amount":"848.22"}}
    }
  }

  function registerUser(string _name, string _password) public {
    require(!users[msg.sender].exist);

    users[msg.sender] = User({
        exist: true,
        name: _name,
        futuresContractID: new uint256[](0),
        passwordHash: keccak256(_password)
      });
  }

  function authenticate(string _password, address _user) private view returns(bool ) {
    // Authenticate Caller User by verifying password
    User memory currentUser = users[_user];
    require(currentUser.exist);

    return(currentUser.passwordHash == keccak256(_password));
  }

}
