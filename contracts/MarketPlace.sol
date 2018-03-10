pragma solidity ^0.4.18;
import './FuturesContract.sol';
import './oraclizeAPI.sol';

contract MarketPlace is usingOraclize {
  // Enum definitions
  enum UserLoginStatus { Online, Offline, Archieved }

  // Unscoped variables
  string public binanceBaseAPI = "https://api.binance.com/api/v3/ticker/price?symbol=";
  string[] public availablePairings = [
    'ETHEOS', 'ETHTRX', 'ETHOMG', 'ETHQTM'
  ];

  uint256 constant timeStampInterval = 3*3600;
  uint256 public userOnlineCount;

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
  uint256[] unsignedFuturesContactIds;

  // Mapping data struct
  mapping(address => User) users;
  mapping(uint256 => FuturesContract) signedFuturesContracts;
  mapping(uint256 => FuturesContract) unsignedFuturesContracts;

  // Event Logs

  // Admin Management Function Modifiers
  modifier onlyOwner() { require(msg.sender == owner);_; }
  // User Management Function Modifiers
  modifier userExist() { require(users[msg.sender].exist);_; }
  modifier notUserExist() { require(!users[msg.sender].exist);_; }
  modifier userIsOnline() { require(users[msg.sender].status == UserLoginStatus.Online);_; }

  // Contructor
  function MarketPlace() public {
    owner = msg.sender;
  }

  function signContractOf(address _seller, address _contractAddress) public payable userExist userIsOnline {
    // Sign contract from another User
    require(users[_seller].exist);

    User seller = users[_seller];
    FuturesContract sellerContract = FuturesContract.at(_contractAddress);
    sellerContract.signContract(msg.sender);
  }

  function createContract(uint256 _expiryDate, uint256 _bettingPairs, uint256 _bettingPrice, string _position)
    public payable userExist userIsOnline {
    // User create new unsigned contract

    User currentUser = users[msg.sender];
    string memory bettingAPI = strConcat(binanceBaseAPI, _bettingPairs);

    FuturesContract newContract = (new FuturesContract).value(msg.sender)(
        msg.sender,
        _expiryDate,
        _bettingPairs,
        _bettingPrice,
        _position,
        bettingAPI
      );

    currentUser.futuresContractID.push(newContract.address);
  }

  // Admin Update Functions
  function updatePairings(string _newPairing) public onlyOwner {
    // Update Existing Pairing with ticker
    availablePairings.push(_newPairing);
  }

  // User Account Management Function
  function registerUser(string _name, string _password) public notUserExist {
    // Params Validation
    require(bytes(_name).length > 3);
    require(bytes(_password).length > 3);

    // Register new user to Contract
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
    userOnlineCount++;
  }

  function logoutUser() public userExist {
    // Authenticate and set user login status to offline
    User storage currentUser = users[msg.sender];
    require(currentUser.status == UserLoginStatus.Online);
    currentUser.status = UserLoginStatus.Offline;
    userOnlineCount--;
  }

  function authenticate(address _user, string _name, string _password) private view returns(bool) {
    // Authenticate Caller User by verifying password
    return(users[_user].passwordHash == keccak256(_password, _name));
  }

}
