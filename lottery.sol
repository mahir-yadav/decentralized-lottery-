//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
contract lottery{
    //basically a manager and some participants will participate in this contract.
    address public manager;
    address payable[] public participants;
    constructor()
    {
        manager=msg.sender;
    }
    receive() external payable{
        //ticket charge is 0.02 ether.
        require(msg.value==0.02 ether);
        participants.push(payable(msg.sender));
    }
    //function for getting total pool.
    function getbalance() public view returns(uint){
        //only manager can see balance.
        require(msg.sender==manager);
        return address(this).balance;
    }
    //function for generating random hash.
    function random() public view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }
    function pickwinner() public{
        //only manager can call pickwinner function.
        require(msg.sender==manager);
        //there should be more than 3 participants.
        require(participants.length>=3);
        uint r= random();
        address payable winner;
        uint index=r%participants.length;
        winner=participants[index];
        winner.transfer(getbalance());
        //reseting after getting winner.
        participants=new address payable[](0);
    }
}
