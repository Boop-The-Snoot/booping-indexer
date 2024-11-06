// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./gen_schema.sol";
import "./gen_events.sol";
import "./gen_base.sol";
import "./gen_helpers.sol";

contract MyIndex is GhostGraph {
    using StringHelpers for EventDetails;
    using StringHelpers for uint256;
    using StringHelpers for address;
    
    function registerHandles() external {
        graph.registerHandle(0xEc9566Dd3ECA280038c2d8e6B391C43989c455Af);
    }
    
    function onUnpaused(EventDetails memory details, UnpausedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onUnclaimedRewardsWithdrawn(EventDetails memory details, UnclaimedRewardsWithdrawnEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onTotalRewardsClaimed(EventDetails memory details, TotalRewardsClaimedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onTokenWhitelisted(EventDetails memory details, TokenWhitelistedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onTokenWhitelistRemoved(EventDetails memory details, TokenWhitelistRemovedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onRoleRevoked(EventDetails memory details, RoleRevokedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onRoleGranted(EventDetails memory details, RoleGrantedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onRoleAdminChanged(EventDetails memory details, RoleAdminChangedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onRewardsClaimed(EventDetails memory details, RewardsClaimedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onRewardTokensWithdrawn(EventDetails memory details, RewardTokensWithdrawnEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onRewardTokensDeposited(EventDetails memory details, RewardTokensDepositedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onReferralMade(EventDetails memory details, ReferralMadeEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onReferralFailed(EventDetails memory details, ReferralFailedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onPaused(EventDetails memory details, PausedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onMinLpTokenAmountUpdated(EventDetails memory details, MinLpTokenAmountUpdatedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onMaxRewardRateIncreased(EventDetails memory details, MaxRewardRateIncreasedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onGlobalRootUpdated(EventDetails memory details, GlobalRootUpdatedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onChangeProposed(EventDetails memory details, ChangeProposedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onChangeExecuted(EventDetails memory details, ChangeExecutedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
    
    function onCampaignCreated(EventDetails memory details, CampaignCreatedEvent memory ev) external {
        // optionally handle this event
        // be sure to store your entities using graph.save<entity>
    }
}