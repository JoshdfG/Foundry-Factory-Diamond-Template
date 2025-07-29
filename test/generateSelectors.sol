// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";

contract GenerateSelectors is Test {
    /// @notice Generates function selectors for a given facet using Foundry's `forge inspect`.
    /// @dev Uses `vm.ffi` to execute a shell command that retrieves method identifiers.
    /// @param _facet The name of the facet contract to inspect.
    /// @return selectors_ An array of function selectors extracted from the facet.
    function generateSelectors(string memory _facet) internal returns (bytes4[] memory selectors_) {
        string[] memory cmd = new string[](5);
        cmd[0] = "forge";
        cmd[1] = "inspect";
        cmd[2] = _facet;
        cmd[3] = "methodIdentifiers";
        cmd[4] = "--json";

        bytes memory res = vm.ffi(cmd);
        string memory output = string(res);

        string[] memory keys = vm.parseJsonKeys(output, "$");
        uint256 keysLength = keys.length;

        // Initialize the selectors array with the selectorCount
        selectors_ = new bytes4[](keysLength);

        for (uint256 i; i < keysLength; ++i) {
            selectors_[i] = bytes4(bytes32(keccak256(bytes(keys[i]))));
        }
    }
}
