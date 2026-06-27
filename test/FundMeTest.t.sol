//SPDX-License-Identifier: MIT



pragma solidity ^0.8.18;


import {Test, console} from 'forge-std/Test.sol';
import {FundMe} from '../src/FundMe.sol';
import {DeployFundMe} from "../script/DeployFundMe.s.sol";


contract FundMeTest is Test{
    uint256 favNumber = 0;
    bool greatCourse = false;
    

FundMe fundMe;
DeployFundMe deployFundMe;

    function setUp() external{ //First thing that happens
        //so that we always deploy in our test setup the exact same way we deploy in our script
         deployFundMe = new DeployFundMe();
         fundMe = deployFundMe.run();
    }
    

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }
    function testPriceFeedVersionIsAccurate() public {
        if (block.chainid == 11155111) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 4);
        } else if (block.chainid == 1) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 6);
        }
  }  

}