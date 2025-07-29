// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "../../libraries/Error.sol";
import "../../libraries/Events.sol";

library LibChild {
    struct Layout {
        uint256 currentNo;
        string name;
        address organisationAdmin;
    }

    function init(address admin) internal {
        Layout storage layout = orgStorage();
        layout.organisationAdmin = admin;
    }

    function ChangeNameAndNo(uint256 _newNo, string memory _newName) internal {
        Layout storage layout = orgStorage();

        layout.currentNo = _newNo;
        layout.name = _newName;
    }

    function getLayout() internal view returns (Layout memory l) {
        Layout storage layout = orgStorage();
        l.currentNo = layout.currentNo;
        l.name = layout.name;
        l.organisationAdmin = layout.organisationAdmin;
    }

    bytes32 constant ORGANISATION_STORAGE_POSITION = keccak256("lib.organisation.storage");

    function orgStorage() internal pure returns (Layout storage org) {
        bytes32 position = ORGANISATION_STORAGE_POSITION;
        assembly {
            org.slot := position
        }
    }
}
