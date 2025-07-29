// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../facets/DiamondCutFacet.sol";
import "../facets/DiamondLoupeFacet.sol";
import "../facets/OwnershipFacet.sol";
import "../child/facets/ChildFacet.sol";

interface IOtherSelectorFacets {
    function getLoupeSelectors() external pure returns (bytes4[] memory);
    function getOwnershipSelectors() external pure returns (bytes4[] memory);
    function setupFacets()
        external
        returns (
            DiamondCutFacet diamondCutFacet,
            DiamondLoupeFacet diamondLoupeFacet,
            OwnershipFacet ownershipFacet,
            ChildFacet childFacet
        );
}
