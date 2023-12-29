// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

abstract contract IStakingPools {

    function deposit(uint amount) public virtual;
    function withdraw(uint amount) public virtual;
    function withdrawPoints() public virtual;
    function getSpeed() public view virtual;
    function getPoints() public view virtual;
    function settlement() public virtual;

    event Deposit(address account, uint amount);
    event Withdraw(address account, uint amount);
    event WithdrawPoints(address account, uint amount);

}