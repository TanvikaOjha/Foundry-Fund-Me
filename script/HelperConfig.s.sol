//SPDX-License-Identifier: MIT

//1.Deploy mocks when we are on a local anvil chain
//2. Keep track of contract address across different chain



pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
​

contract HelperConfig is Script{
    // If we are on a local Anvil, we deploy the mocks
    // Else, grab the existing address from the live network
    struct NetworkConfig {
        address priceFeed; //ETH/USD price feed address
    }
    NetworkConfig public activeNetworkConfig;
    MockV3Aggregator mockPriceFeed;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;  

    constructor(){
        if(block.chainid == 11155111){//block.chainId = unique indentifier of the blockchain network in which curret block is being processed.
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
        
    }
    function getOrCreateAnvilEthConfig() public pure returns (NetworkConfig memory) {
      if(activeNetworkConfig.priceFeed != address(0)){
        return activeNetworkConfig;  //to prevent redeployment
      }
      //1.Deploy the mocks
      //2.Return the mock address
      vm.startBroadcast();
      mockPriceFeed = new MockV3Aggregator(8, 2000e8);
      vm.stopBroadcast();
      NetworkConfig memory anvilConfig = NetworkConfig({
        priceFeed: address(mockPriceFeed)
      });
      return anvilConfig;

    }
}