// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ChildFacet} from "../child/facets/ChildFacet.sol";

contract ChildSelectorsFacet {
    function getChildSelectors() external pure returns (bytes4[] memory) {
        bytes4[] memory selectors = new bytes4[](3);

        selectors[0] = ChildFacet.ChangeNameAndNo.selector;
        selectors[1] = ChildFacet.getLayout.selector;
        selectors[2] = ChildFacet.init.selector;

        return selectors;
    }
}
