// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibChild} from "../libraries/LibChild.sol";
import "../../libraries/Error.sol";
import "../../libraries/LibUtils.sol";

contract ChildFacet {
    function init(address admin) external {
        LibChild.init(admin);
    }

    function ChangeNameAndNo(uint256 _newNo, string memory _newName) external {
        LibChild.ChangeNameAndNo(_newNo, _newName);
    }

    function getLayout() external view returns (LibChild.Layout memory) {
        return LibChild.getLayout();
    }
}
