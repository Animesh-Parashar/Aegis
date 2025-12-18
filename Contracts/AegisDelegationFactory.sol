// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./AegisDelegation.sol";

contract AegisDelegationFactory {
    event DelegationCreated(address delegation, address owner);

    function createDelegation(
        address usdc,
        uint256 dailyLimit,
        uint256 cooldown
    ) external returns (address) {
        AegisDelegation delegation =
            new AegisDelegation(
                msg.sender,
                usdc,
                dailyLimit,
                cooldown
            );

        emit DelegationCreated(address(delegation), msg.sender);
        return address(delegation);
    }
}
