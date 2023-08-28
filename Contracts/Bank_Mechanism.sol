// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BankMechanism {
    address private ownerAddress;
    mapping(address => uint256) private bankAccounts;
    mapping(address => bool) private authorisedAccountOwners;
    uint256 private minimumAccountOpeningBalance;

    constructor() {
        ownerAddress = msg.sender;
        minimumAccountOpeningBalance = 2 * 1e15 wei;
    }

    modifier onlyOwner {
        require(msg.sender == ownerAddress, "Only the owner can call this function");
        _;
    }

    modifier authorisedAddresses {
        require(authorisedAccountOwners[msg.sender], "Only authorised account owners can call this function");
        _;
    }

    modifier minimumAmountToOpenAccount {
        require(msg.value >= minimumAccountOpeningBalance, "Insufficient opening balance");
        _;
    }

    modifier balanceLessThanTransactionAmount {
        require(bankAccounts[msg.sender] > msg.value, "Insufficient balance for this transaction");
        _;
    }

    function openAccount() public payable minimumAmountToOpenAccount {
        bankAccounts[msg.sender] = msg.value;
        authorisedAccountOwners[msg.sender] = true;
    }

    function deposit() public payable authorisedAddresses returns (uint256) {
        bankAccounts[msg.sender] += msg.value;
        return bankAccounts[msg.sender];
    }

    function checkBalanceByContractOwner(address accountOwner) public view onlyOwner returns(uint256) {
        return bankAccounts[accountOwner];
    }

    function checkBalanceByAccountOwner() public view authorisedAddresses returns (uint256) {
        return bankAccounts[msg.sender];
    }

    function transfer(address payable recipient) public payable authorisedAddresses balanceLessThanTransactionAmount returns (bool) {
        if (msg.value <= bankAccounts[msg.sender]) {
            recipient.transfer(msg.value);
            bankAccounts[msg.sender] -= msg.value;
            return true;
        }
        return false;
    }
}
