// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../facets/DiamondCutFacet.sol";

interface IDeployChildDiamondFacet {
    function init_selector(address _childSelectorsFacet, address _otherSelectorsFacet) external;
    function deployChildDiamond() external returns (FacetCut[] memory);
}
