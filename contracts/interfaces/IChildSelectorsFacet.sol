// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IChildSelectorsFacet {
    function getChildSelectors() external pure returns (bytes4[] memory);
}
