//SPDX-license-Identifier: MIT

pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/mockV3aggregatorInterface.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    struct NetworkConfig {
        address PriceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getorCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory Sepoliaconfig = NetworkConfig({
            PriceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return Sepoliaconfig;
    }

    function getorCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.PriceFeed == address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({
            PriceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
