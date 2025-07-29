// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/DiamondCutFacet.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";
import "../contracts/libraries/LibUtils.sol";
import "./../contracts/child/facets/ChildFacet.sol";
import "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/OrganisationFactoryFacet.sol";
import "../contracts/facets/CreateChildFacet.sol";
import "../contracts/facets/DeployChildDiamondFacet.sol";
import "../contracts/facets/ChildSelectorsFacet.sol";
import "../contracts/facets/OtherSelectorFacets.sol";
import "../lib/forge-std/src//Test.sol";
import "../contracts/Diamond.sol";
import "../contracts/libraries/Error.sol";
import "../contracts/child/libraries/LibChild.sol";
import "../contracts/interfaces/IChild.sol";
import "../test/generateSelectors.sol";

contract DiamondDeployer is Test, IDiamondCut,GenerateSelectors {
    Diamond diamond;
    DiamondCutFacet dCutFacet;
    DiamondLoupeFacet dLoupe;
    OwnershipFacet ownerF;

    DeployChildDiamondFacet deployChildDiamondFacet;
    CreateChildFacet deployFacet;
    OtherSelectorFacets otherSelectorFacets;

    ChildSelectorsFacet childSelectorFacet;
    OrganisationFactoryFacet orgFacetFactory;
    ChildFacet orgF;

    address public organisationAddress;
    address director = makeAddr("1");

    function setUp() public {
        dCutFacet = new DiamondCutFacet();
        dLoupe = new DiamondLoupeFacet();
        ownerF = new OwnershipFacet();

        deployChildDiamondFacet = new DeployChildDiamondFacet();
        deployFacet = new CreateChildFacet();

        orgFacetFactory = new OrganisationFactoryFacet();
        otherSelectorFacets = new OtherSelectorFacets();
        childSelectorFacet = new ChildSelectorsFacet();
        bytes memory initCalldata = abi.encodeWithSelector(
            orgFacetFactory.initializeAll.selector,
            address(deployFacet),
            address(deployChildDiamondFacet),
            address(childSelectorFacet),
            address(otherSelectorFacets)
        );

        FacetCut[] memory cut = new FacetCut[](7);
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
            facetAddress: address(deployChildDiamondFacet),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("DeployChildDiamondFacet")
        });
        cut[3] = FacetCut({
            facetAddress: address(deployFacet),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("CreateChildFacet")
        });
        cut[4] = FacetCut({
            facetAddress: address(orgFacetFactory),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("OrganisationFactoryFacet")
        });
        cut[5] = FacetCut({
            facetAddress: address(otherSelectorFacets),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("OtherSelectorFacets")
        });
        cut[6] = FacetCut({
            facetAddress: address(childSelectorFacet),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("ChildSelectorsFacet")
        });

        diamond = new Diamond(address(this), cut, address(orgFacetFactory), initCalldata);

        orgFacetFactory = OrganisationFactoryFacet(address(diamond));

        console.log("DeployOrgDiamondFacet after setup:", orgFacetFactory.deployOrgDiamondFacet());

        if (orgFacetFactory.deployOrgDiamondFacet() == address(0)) {
            revert Error.INITIALIZATION_FAILED();
        }
    }

    function testInitialization() public {
        assertEq(orgFacetFactory.deployOrgDiamondFacet(), address(deployChildDiamondFacet));
    }

    function testCreateChild() public {
        vm.startPrank(director);

        orgFacetFactory.createorganisation();

        address child = orgFacetFactory.getUserOrganisatons(director)[0];

        console.log("User orgs length:", child);
    }

    function testLayoutfacet() public {
        testCreateChild();

        address child = orgFacetFactory.getUserOrganisatons(director)[0];

        ICHILD(child).ChangeNameAndNo(777, "one guy");
        ICHILD.Layout memory layout = ICHILD(child).getLayout();

        assertEq(layout.currentNo, 777);
        assertEq(layout.name, "one guy");
    }

    function testGetLayout() public {
        testLayoutfacet();

        address child = orgFacetFactory.getUserOrganisatons(director)[0];

        ICHILD.Layout memory layout = ICHILD(child).getLayout();

        assertEq(layout.currentNo, 777);
        assertEq(layout.name, "one guy");
    }

    function diamondCut(FacetCut[] calldata _diamondCut, address _init, bytes calldata _calldata) external override {}
}
