pragma solidity ^0.4.18;
import './FuturesContract.sol';
import './oraclizeAPI.sol';

contract MarketPlace is usingOraclize {
  // Enum definitions
  enum UserLoginStatus { Online, Offline, Archieved }

  // Unscoped variables
  string public binanceBaseAPI = "https://api.binance.com/api/v3/ticker/price?symbol=";
  string[] public allowedPairings;

  uint256 constant timeStampInterval = 3*3600;
  uint256 public totalOnlineUsers;

  address owner;

  // Struct definitions
  struct User {
    bool exist; // For existance validation
    string name;
    UserLoginStatus status; // User online status
    uint256[] futuresContractID; // Stores list of signed contracts
    bytes32 passwordHash;
  }

  address[] userAddresses;
  uint256[] signedFuturesContactIds;
  uint256[] unsignedFuturesContactIds;

  // Mapping data struct
  mapping(address => User) users;
  mapping(uint256 => FuturesContract) signedFuturesContracts;
  mapping(uint256 => FuturesContract) unsignedFuturesContracts;

  // Event Logs

  // Function  Modifiers
  modifier onlyBy(address _account) {
    require(msg.sender == _account);
    _;
  }

  modifier userExist() {
    require(users[msg.sender].exist);
    _;
  }

  function MarketPlace() public {
    // Triggers recursive callback for ETH-USD pairing prices
    owner = msg.sender;
  }

  function registerUser(string _name, string _password) public {
    require(bytes(_name).length > 3);
    require(bytes(_password).length > 3);
    require(!users[msg.sender].exist);
    // Register new user to contract
    users[msg.sender] = User({
        exist: true,
        name: _name,
        status: UserLoginStatus.Offline,
        futuresContractID: new uint256[](0),
        passwordHash: keccak256(_password, _name)
      });
  }

  function loginUser(string _name, string _password) public userExist {
    // Authenticate and set user login status to online
    require(authenticate(msg.sender, _name, _password));
    users[msg.sender].status = UserLoginStatus.Online;
    totalOnlineUsers++;
  }

  function logoutUser() public userExist onlyBy(msg.sender) {
    // Authenticate and set user login status to offline
    User storage currentUser = users[msg.sender];
    require(currentUser.status == UserLoginStatus.Online);
    currentUser.status = UserLoginStatus.Offline;
    totalOnlineUsers--;
  }

  function authenticate(address _user, string _name, string _password) private view returns(bool) {
    // Authenticate Caller User by verifying password
    return(users[_user].passwordHash == keccak256(_password, _name));
  }

}
