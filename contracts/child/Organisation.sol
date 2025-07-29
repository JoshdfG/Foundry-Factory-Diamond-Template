// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../Diamond.sol";
import {IDiamondCut, FacetCut, FacetCutAction} from "../interfaces/IDiamondCut.sol";

contract Organisation is Diamond {
    constructor(address _contractOwner, FacetCut[] memory _diamondCutFacet, address _init, bytes memory _calldata)
        Diamond(_contractOwner, _diamondCutFacet, _init, _calldata)
    {
        // No additional logic needed here; Diamond constructor handles everything
    }
}
