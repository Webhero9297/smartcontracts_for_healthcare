pragma solidity ^0.4.24;

contract Insurance {
  address Owner;

  struct citizen {
    bool isuidgenerated;
    string name;
    uint amountInsured;
  }

  mapping (address => citizen) public citizenmapping;
  mapping (address => bool) public doctormapping;

  constructor() {
    Owner = msg.sender;
  }

  modifier onlyOwner() {
    require( Owner == msg.sender );
    _;
  }

  function setDoctor(address _address) onlyOwner {
    require(!doctormapping[_address]);
    doctormapping[_address] = true;
  }

  function setCitizenData( string _name, uint _amountInsured ) onlyOwner returns (address) {
    address uniqueId = address(sha256(msg.sender, now));
    require(!citizenmapping[uniqueId].isuidgenerated);
    citizenmapping[uniqueId].isuidgenerated = true;
    citizenmapping[uniqueId].name = _name;
    citizenmapping[uniqueId].amountInsured = _amountInsured;

    return uniqueId;
  }

  function useInsurance(address _uniqueId, uint _amountUsed) returns (string) {
    require(doctormapping[msg.sender]);
    if (citizenmapping[_uniqueId].amountInsured < _amountUsed) {
      throw;
    }
    citizenmapping[_uniqueId].amountInsured -= _amountUsed;

    return "Insurance has been used successfully";
  }
  
}