/// SPDX-License-Identifier: MIT
pragma solidity =0.8.21;

import {LibString} from "solmate/utils/LibString.sol";
import "forge-std/Script.sol";
import "src/NameWrapperProxy.sol";

contract DeployNameWrapperProxy is Script {
    address public nameWrapperAddress;
    NameWrapperProxy public nameWrapperProxy;

    function setUp() public {
        uint256 chainId;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            chainId := chainid()
        }
        nameWrapperAddress = vm.envAddress(string.concat("NAME_WRAPPER_", LibString.toString(chainId)));
        this;
    }

    function run() public {
        vm.startBroadcast();

        nameWrapperProxy = new NameWrapperProxy(INameWrapper(nameWrapperAddress));

        vm.stopBroadcast();
    }
}
