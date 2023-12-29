// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "./IStakingPools.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakingPools is IStakingPools, ERC20 {

    mapping(address => uint) public startBlockNumber;
    mapping(address => uint) public userAmount;


    function deposit(uint amount) public override {

    }

    function withdraw(uint amount) public override {
        
    }

    function withdrawPoints() public override {
        
    }

    function getSpeed() public view override {
        
    }

    function getPoints() public view override {
        
    }

    function settlement() public override {
        
    }

}