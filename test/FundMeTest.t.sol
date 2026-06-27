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

address constant USER = makeAddr("user");
uint256 constant SEND_VALUE = 0.1 ether;
uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external{ //First thing that happens
        //so that we always deploy in our test setup the exact same way we deploy in our script
         deployFundMe = new DeployFundMe();
         fundMe = deployFundMe.run();
         vm.deal(USER, STARTING_BALANCE );
    }
    

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }
    function testOwnerIsMagSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
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

function testFundFailsWithoutEnoughETH() public {
    vm.expectRevert();//the next line should revert
    //assert(This tx fails/reverts)
    fundMe.fund(); //send 0 value
}
function testFundUpdatesFundedDataStructure() public {
    vm.prank(USER); //the next TX will be sent by USER
    fundMe.fund(value: SEND_VALUE)();

    uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
    assertEq(amountFunded, SEND_VALUE);
}

function testAddsFunderToArrayOfFunders() public {
    vm.prank(USER);
    fundMe.fund(value: SEND_VALUE)();

    address funder = fundMe.getFunder(0);
    assertEq(funder, USER);
}
modifier funded() {
    vm.prank(USER);
    fundMe.fund{value: SEND_VALUE}();
    _;
}

function testOnlyOwnerCanWithdraw() public funded {
    vm.prank(USER);
    vm.expectRevert();
    fundMe.withdraw();
}
function testWithDrawWithASingleFunder() public funded {
    //Arrange
    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance;
    //Act
    vm.prank(fundMe.getOwner());
    fundMe.withdraw();
    //Assert
    uint256 endingOwnerBalance = fundMe.getOwner().balance;
    uint256 endingFundMeBalance = address(fundMe.balance);
    assertEq(endingFundMeBalance, 0);
    assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
}

function testWithdrawFromMultipleFunders() public funded {
    //ARRANGE
    uint160 numberOfFunders = 10; //to generate adddress from number use uint160
    uint256 startingFunderIndex = 1;
    for(uint160 i = startingFunderIndex; i < numberOfFunders; i++){
        //vm.prank new address
        //vm.deal new address
        //address()
        hoax(address(i), SEND_VALUE);
        fundMe.fund{value: SEND_VALUE}();

    }
    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance;
//ACT
    vm.prank(fundMe.getOwner());
    fundMe.withdraw();
//ASSERT
    assert(address(fundMe).balance == 0);
    assert( startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
}
}