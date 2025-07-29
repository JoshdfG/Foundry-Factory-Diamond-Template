// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICreateChildFacet {
    function create_child(address creator) external returns (address organisation);
}
