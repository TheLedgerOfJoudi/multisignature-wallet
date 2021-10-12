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
    using SafeMath for uint256;
    
    constructor (address _owner1, address _owner2) public {
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
        require (_id <= transactions.length);
        if(msg.sender == owner1){
            transactions[_id].signedByOwnerOne = true;    
        }
        else {
            transactions[_id].signedByOwnerTwo = true;
        }
        withdraw(_id);
    }
    
    function withdraw (uint _id) private{
        require (_id <= transactions.length);
        require(address(this).balance >= transactions[_id].amount);
        Transaction memory transaction = transactions[_id];
        if(transaction.signedByOwnerOne && transaction.signedByOwnerTwo){
            transaction.to.transfer(transaction.amount);
            transaction.amount = 0;
        }
    }
    
    fallback() external payable{}
    
    function getBalance()public view onlyOwner returns (uint256){
        return address(this).balance;
    }
    function getTransactions() public view onlyOwner returns(Transaction[] memory){
        return transactions;
        }
    
}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}
