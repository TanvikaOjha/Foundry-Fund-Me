//SPDX-License-Identifier: MIT

//1.Deploy mocks when we are on a local anvil chain
//2. Keep track of contract address across different chain



pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig {
    // If we are on a local Anvil, we deploy the mocks
    // Else, grab the existing address from the live network
    struct NetworkConfig {
        address priceFeed; //ETH/USD price feed address
    }
    NetworkConfig public activeNetworkConfig;


    constructor(){
        if(block.chainid == 11155111){//block.chainId = unique indentifier of the blockchain network in which curret block is being processed.
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
        
    }
    function getAnvilEthConfig() public pure returns (NetworkConfig memory) {

    }
}