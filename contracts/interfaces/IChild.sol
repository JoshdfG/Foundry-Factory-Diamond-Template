// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICHILD {
    struct Layout {
        uint256 currentNo;
        string name;
        address organisationAdmin;
    }

    function ChangeNameAndNo(uint256 _newNo, string memory _newName) external;
    function getLayout() external view returns (Layout memory);
}
