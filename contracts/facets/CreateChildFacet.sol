// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IDeployChildDiamondFacet.sol";
import "../libraries/LibUtils.sol";
import {ChildFacet} from "../child/facets/ChildFacet.sol";
import "../interfaces/ICreateChildFacet.sol";
import "../child/Organisation.sol";
import "../libraries/Events.sol";

contract CreateChildFacet is ICreateChildFacet {
    function create_child(address creator) external returns (address organisation) {
        LibUtils.Factory storage f = LibUtils.factoryStorage();

        f.organisationAdmin = creator;

        if (f.DeployOrgDiamondFacet == address(0)) revert Error.DEPLOY_ORG_DIAMOND_FACET_NOT_INITIALIZED();

        IDeployChildDiamondFacet deployFacet = IDeployChildDiamondFacet(f.DeployOrgDiamondFacet);

        deployFacet.init_selector(f.OrganisationSelectorsFacet, f.OtherSelectorFacet);

        FacetCut[] memory cut = deployFacet.deployChildDiamond();

        if (cut.length != 4) {
            revert Error.INVALID_NUMBER_OF_FACETS_RETURNED();
        }

        bytes memory initCalldata = abi.encodeWithSelector(ChildFacet.init.selector, creator);

        Organisation orgAdd = new Organisation(creator, cut, address(this), initCalldata);

        address organisationAddress = address(orgAdd);

        ChildFacet(address(organisationAddress)).init(creator);

        f.Organisations.push(address(organisationAddress));

        f.validOrganisation[address(organisationAddress)] = true;

        uint256 orgLength = f.memberOrganisations[creator].length;

        f.studentOrganisationIndex[creator][address(organisationAddress)] = orgLength;

        f.memberOrganisations[creator].push(address(orgAdd));

        organisation = organisationAddress;

        emit Events.DebugLog(creator, orgLength, address(organisationAddress), f.memberOrganisations[msg.sender].length);

        return (organisation);
    }
}
