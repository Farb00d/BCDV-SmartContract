//SPDX-License-Identiefier: MIT
pragma solidity ^0.5.7;

contract LastWillAndTestament {

    address owner;
    uint funds;
    bool isDeceased;

    constructor() public payable {
        owner = msg.sender;
        funds = msg.value;
        isDeceased = false;
    }

    modifier onlyOwner() {
        require(msg.sender==owner, "You are not the owner of the contract.");
        _;
    }

    modifier isOwnerDeceased() {
        require(isDeceased==true, "Contract owner must be deceased for fund to be distributed.");
        _;
    }
    // 1.refactor the code to use an array of Structs to hold the beneficiary information, 
    // without using a mapping. 

    /* address payable[] beneficiaryAccounts;
       mapping(address=>uint) inheritance; */

    struct Beneficiary {
        address payable account;
        uint inheritanceAmount;
    }
    Beneficiary[] beneficiaries;


    // 2. create a function to translate the Value entered in Ether to Wei. 

    /*function setInheritance(address payable _account, uint _inheritAmt) public onlyOwner {
        beneficiaryAccounts.push(_account);
        inheritance[_account] = _inheritAmt;
    }*/

    function setInheritanceEther(address payable _account, uint _inheritAmtEther) public onlyOwner {
        uint _inheritAmtWei = _inheritAmtEther * 1 ether;
    
    
    // 3. Add some require statement(s) to make sure the balance in the contract is sufficient to 
    // cover the setInheritance values. 
  
        require(address(this).balance >= _inheritAmtWei, "Insufficient balance in contract to cover inheritance amount.");
        Beneficiary memory newBeneficiary = Beneficiary(_account, _inheritAmtWei);
        beneficiaries.push(newBeneficiary);
    }

    function distributeFunds() private isOwnerDeceased {
        for(uint i=0; i<beneficiaries.length; i++) {
            beneficiaries[i].account.transfer(beneficiaries[i].inheritanceAmount);
        }
    }

    function deceased() public onlyOwner {
        isDeceased = true;
        distributeFunds();
    }

}
