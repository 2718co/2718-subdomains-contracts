// SPDX-License-Identifier: MIT
pragma solidity =0.8.21;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/NameWrapperProxy.sol";

contract NameWrapperMock {
    mapping(bytes32 => bytes) public names;

    constructor(bytes32 node, bytes memory name) {
        names[node] = name;
    }
}

contract NameWrapperProxyTest is Test {
    NameWrapperProxy public nameWrapperProxy;
    // parentnode juanpablo.eth
    bytes32 public parentNode = 0xc7e727f7afad347bdab4ba1d6dd473c0fa23f9c8be6daedb05a3297f8055922d;
    // node and name for pedro.juanpablo.eth
    bytes32 public node = 0xb01692de226c7839d77f4f2303ddb2487fd41e4b865b6de80b67771a6b59b2b6;
    bytes public name = hex"b01692de226c7839d77f4f2303ddb2487fd41e4b865b6de80b67771a6b59b2b6";

    function setUp() public {
        NameWrapperMock nameWrapperMock = new NameWrapperMock(node, name );
        nameWrapperProxy = new NameWrapperProxy(INameWrapper(address(nameWrapperMock)));
    }

    function test_GetNodeName() public {
        // name that does not exist
        bytes32 inexistentNode = nameWrapperProxy.getNode("areo", parentNode);
        assertEq(keccak256(nameWrapperProxy.getNodeName(inexistentNode)), keccak256(hex""));
        // name that exists
        assertEq(keccak256(nameWrapperProxy.getNodeName(node)), keccak256(name));
    }

    function test_Node() public {
        assertEq(nameWrapperProxy.getNode("pedro", parentNode), node);
    }

    function test_ParentNode() public {
        assertEq(nameWrapperProxy.getParentNode("juanpablo"), parentNode);
    }

    function test_RevertWhen_DomainEmpty() public {
        vm.expectRevert("Domain cannot be empty");
        nameWrapperProxy.getParentNode("");
    }

    function test_RevertWhen_LabelEmpty() public {
        vm.expectRevert("Label cannot be empty");
        nameWrapperProxy.setSubnodeRecord(parentNode, "", address(2), address(3), 0, 0, 0);
    }

    function test_RevertWhen_ParentNodeEmpty() public {
        vm.expectRevert("Parent node cannot be empty");
        nameWrapperProxy.setSubnodeRecord(bytes32(0), "pedro", address(2), address(3), 0, 0, 0);
    }


    function test_RevertWhen_SubdomainAlreadyExists() public {
        vm.expectRevert("Subdomain already exists");
        nameWrapperProxy.setSubnodeRecord(parentNode, "pedro", address(2), address(3), 0, 0, 0);
    }

    function test_RevertWhen_SubdomainEmpty() public {
        vm.expectRevert("Subdomain cannot be empty");
        nameWrapperProxy.getNode("", parentNode);
    }
}
