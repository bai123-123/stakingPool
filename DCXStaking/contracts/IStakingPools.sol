pragma solidity ^0.6.6;

 interface  IStakingPools {

    // function deposit(uint amount) external view;
    // function withdraw(uint amount) external view;
    // function withdrawPoints() external view;
    // function getSpeed() external view;
    // function getPoints() external view;
    // function settlement() external view;

    event Deposit(address account, uint amount);
    event Withdraw(address account, uint amount);

}