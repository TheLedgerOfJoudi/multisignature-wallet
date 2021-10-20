//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;
pragma experimental ABIEncoderV2;

contract MultiSig {
    address public owner1;
    address public owner2;
    struct Transaction {
        address payable to;
        uint amount;
        bool signedByOwnerOne;
        bool signedByOwnerTwo;
    }
    Transaction[] public transactions;
    
    constructor (address _owner1, address _owner2) {
        owner1 = _owner1;
        owner2 = _owner2;
    }
    
    modifier onlyOwner(){
        require (msg.sender == owner1 || msg.sender == owner2);
        _;
    }
    
    function initiateTransaction (address payable _to, uint _amount) public onlyOwner{
    Transaction memory transaction; 
    transaction.to = _to;
    transaction.amount = _amount;
    if(msg.sender == owner1){
        transaction.signedByOwnerOne = true;
    }
    else{
        transaction.signedByOwnerTwo = true;
    }
    transactions.push(transaction);
    
    }
    
    function approveTransaction (uint _id) public onlyOwner{
        require (_id < transactions.length);
        if(msg.sender == owner1){
            transactions[_id].signedByOwnerOne = true;    
        }
        else {
            transactions[_id].signedByOwnerTwo = true;
        }
        withdraw(_id);
    }
    
    function withdraw (uint _id) private{
        require (_id < transactions.length);
        require(address(this).balance >= transactions[_id].amount);
        require(transactions[_id].signedByOwnerOne && transactions[_id].signedByOwnerTwo);
        require(transactions[_id].amount != 0);
            transactions[_id].to.transfer(transactions[_id].amount);
            transactions[_id].amount = 0;
    }
    
    fallback() external payable{}
    receive() external payable{}
    
    function getBalance()public view  returns (uint256){
        return address(this).balance;
    }
    
    function getTransactions() public view returns(Transaction[] memory){
        return transactions;
        }
        
}


