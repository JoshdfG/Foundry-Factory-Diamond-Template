// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/forge-std/src/Script.sol";
import "../contracts/facets/DiamondCutFacet.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";
import "../contracts/facets/OrganisationFactoryFacet.sol";
import "../contracts/facets/CreateChildFacet.sol";
import "../contracts/facets/DeployChildDiamondFacet.sol";
import "../contracts/child/facets/ChildFacet.sol";
import "../contracts/Diamond.sol";
import {FacetCut, FacetCutAction} from "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/OtherSelectorFacets.sol";
import "../contracts/facets/ChildSelectorsFacet.sol";
import "../test/generateSelectors.sol";

contract DiamondUpgradeScript is Script, GenerateSelectors {
    function deployMainDiamond() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        console.log("Deployer address: %s", deployer);
        vm.startBroadcast(deployerPrivateKey);

        DiamondCutFacet dCut = new DiamondCutFacet();
        console.log("DiamondCutFacet deployed: %s", address(dCut));

        DiamondLoupeFacet dLoupe = new DiamondLoupeFacet();
        console.log("DiamondLoupeFacet deployed: %s", address(dLoupe));

        OwnershipFacet ownerF = new OwnershipFacet();
        console.log("OwnershipFacet deployed: %s", address(ownerF));

        DeployChildDiamondFacet deployChildFacet = new DeployChildDiamondFacet();
        console.log("DeployChildDiamondFacet deployed: %s", address(deployChildFacet));

        CreateChildFacet createChildFacet = new CreateChildFacet();
        console.log("CreateOrganisationFacet deployed: %s", address(createChildFacet));

        OrganisationFactoryFacet orgFactoryFacet = new OrganisationFactoryFacet();
        console.log("OrganisationFactoryFacet deployed: %s", address(orgFactoryFacet));

        OtherSelectorFacets otherSelectorFacets = new OtherSelectorFacets();
        console.log("OtherSelectorFacets deployed: %s", address(otherSelectorFacets));

        ChildSelectorsFacet childSelectorsFacet = new ChildSelectorsFacet();
        console.log("ChildSelectorsFacet deployed: %s", address(childSelectorsFacet));

        FacetCut[] memory cut = new FacetCut[](8);
        cut[0] = FacetCut({
            facetAddress: address(dLoupe),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("DiamondLoupeFacet")
        });
        cut[1] = FacetCut({
            facetAddress: address(ownerF),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("OwnershipFacet")
        });
        cut[2] = FacetCut({
            facetAddress: address(deployChildFacet),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("DeployChildDiamondFacet")
        });
        cut[3] = FacetCut({
            facetAddress: address(createChildFacet),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("CreateChildFacet")
        });
        cut[4] = FacetCut({
            facetAddress: address(orgFactoryFacet),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("OrganisationFactoryFacet")
        });
        cut[5] = FacetCut({
            facetAddress: address(otherSelectorFacets),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("OtherSelectorFacets")
        });
        cut[6] = FacetCut({
            facetAddress: address(childSelectorsFacet),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("ChildSelectorsFacet")
        });
        cut[7] = FacetCut({
            facetAddress: address(dCut),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("DiamondCutFacet")
        });

        bytes memory initCalldata = abi.encodeWithSelector(
            OrganisationFactoryFacet.initializeAll.selector,
            address(createChildFacet),
            address(deployChildFacet),
            address(childSelectorsFacet),
            address(otherSelectorFacets)
        );

        console.log("Deploying Diamond...");
        Diamond diamond = new Diamond(deployer, cut, address(orgFactoryFacet), initCalldata);
        address diamondAddress = address(diamond);
        console.log("Main Diamond (factory) deployed: %s", diamondAddress);

        bytes memory constructorArgs = abi.encode(deployer, cut, address(orgFactoryFacet), initCalldata);
        console.log("Constructor arguments (hex): %s", vm.toString(constructorArgs));

        console.log("Creating child...");
        OrganisationFactoryFacet orgFactory = OrganisationFactoryFacet(diamondAddress);
        (address child) = orgFactory.createorganisation();

        console.log("Organisation deployed: %s", child);

        vm.stopBroadcast();

        writeAddressesToFile(address(orgFactoryFacet), "orgFactoryFacet");
        writeAddressesToFile(diamondAddress, "Diamond address");
        writeAddressesToFile(child, "Child address");
    }

    function writeAddressesToFile(address addr, string memory text) public {
        string memory filename = "./foundry_base_sepolia.txt";

        vm.writeLine(filename, "-------------------------------------------------");
        vm.writeLine(filename, text);
        vm.writeLine(filename, vm.toString(addr));
        vm.writeLine(filename, "-------------------------------------------------");
    }
}
