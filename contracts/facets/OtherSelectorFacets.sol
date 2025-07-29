// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IDiamondCut.sol";
import "../interfaces/IERC173.sol";
import "../facets/OwnershipFacet.sol";
import "../interfaces/IOtherSelectorFacets.sol";

contract OtherSelectorFacets is IOtherSelectorFacets {
    function getLoupeSelectors() external pure returns (bytes4[] memory) {
        bytes4[] memory loupeSelectors = new bytes4[](5);
        loupeSelectors[0] = IDiamondLoupe.facets.selector;
        loupeSelectors[1] = IDiamondLoupe.facetFunctionSelectors.selector;
        loupeSelectors[2] = IDiamondLoupe.facetAddresses.selector;
        loupeSelectors[3] = IDiamondLoupe.facetAddress.selector;
        loupeSelectors[4] = IERC165.supportsInterface.selector;
        return loupeSelectors;
    }

    function getOwnershipSelectors() external pure returns (bytes4[] memory) {
        bytes4[] memory ownershipSelectors = new bytes4[](2);
        ownershipSelectors[0] = IERC173.transferOwnership.selector;
        ownershipSelectors[1] = IERC173.owner.selector;
        return ownershipSelectors;
    }

    function setupFacets()
        external
        returns (
            DiamondCutFacet diamondCutFacet,
            DiamondLoupeFacet diamondLoupeFacet,
            OwnershipFacet ownershipFacet,
            ChildFacet childFacet
        )
    {
        diamondCutFacet = new DiamondCutFacet();
        diamondLoupeFacet = new DiamondLoupeFacet();
        ownershipFacet = new OwnershipFacet();
        childFacet = new ChildFacet();
    }
}
