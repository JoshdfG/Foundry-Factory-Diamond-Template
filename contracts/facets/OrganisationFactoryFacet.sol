// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CreateChildFacet.sol";
import "../libraries/LibUtils.sol";
import "../../lib/forge-std/src/console.sol";

contract OrganisationFactoryFacet {
    function initializeAll(
        address _createOrganisationFacet,
        address _deployOrgDiamondFacet,
        address _organisationsSelectorsFacet,
        address _otherSelectorsFacet
    ) public {
        LibUtils.initializeCreateOrganisationFacet(_createOrganisationFacet);
        LibUtils.initDeployOrgDiamondFacet(_deployOrgDiamondFacet);
        LibUtils.initializeSelectorsFacet(_organisationsSelectorsFacet);
        LibUtils.initializeOtherSelectorsFacet(_otherSelectorsFacet);
    }

    function deployOrgDiamondFacet() external view returns (address) {
        return LibUtils.factoryStorage().DeployOrgDiamondFacet;
    }

    function createorganisation() external returns (address organisation) {
        return CreateChildFacet(address(this)).create_child(msg.sender);
    }

    function getOrganizations() public view returns (address[] memory) {
        LibUtils.Factory storage f = LibUtils.factoryStorage();

        return f.Organisations;
    }

    function getUserOrganisatons(address _userAddress) public view returns (address[] memory) {
        LibUtils.Factory storage f = LibUtils.factoryStorage();

        return (f.memberOrganisations[_userAddress]);
    }
}
