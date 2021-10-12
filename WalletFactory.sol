//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;
pragma experimental ABIEncoderV2;
import "./MultiSig.sol";

contract WalletFactory {
    address public wallet = 0x0000000000000000000000000000000000000000;
    
    constructor (address _owner1, address _owner2){
    wallet = address(new MultiSig(_owner1, _owner2));
    }
    
}
