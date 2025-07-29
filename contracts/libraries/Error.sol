// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Error {
    error ALREADY_INITIALIZED();
    error DEPLOY_ORG_DIAMOND_FACET_NOT_INITIALIZED();
    error INVALID_NUMBER_OF_FACETS_RETURNED();
    error INITIALIZATION_FAILED();
}
