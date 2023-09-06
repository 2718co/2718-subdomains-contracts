/// SPDX-License-Identifier: MIT
pragma solidity =0.8.21;

interface INameWrapper {
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;

    function setSubnodeRecord(
        bytes32 parentNode,
        string memory label,
        address owner,
        address resolver,
        uint64 ttl,
        uint32 fuses,
        uint64 expiry
    ) external returns (bytes32 node);
}
