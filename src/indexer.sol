// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./gen_schema.sol";
import "./gen_events.sol";
import "./gen_base.sol";
import "./gen_helpers.sol";

interface IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
}

contract BoopTheSnootIndex is GhostGraph {
    using StringHelpers for EventDetails;
    using StringHelpers for uint256;
    using StringHelpers for address;
    
    function registerHandles() external {
        graph.registerHandle(0xEc9566Dd3ECA280038c2d8e6B391C43989c455Af);
    }
    
    function onUnpaused(EventDetails memory details, UnpausedEvent memory ev) external {
        // Track system state
        SystemState memory state = graph.getSystemState("GLOBAL");
        state.isPaused = false;
        state.lastUnpausedAt = details.timestamp;
        state.lastUnpausedTx = details.transactionHash;
        graph.saveSystemState(state);
    }
    
    function onUnclaimedRewardsWithdrawn(EventDetails memory details, UnclaimedRewardsWithdrawnEvent memory ev) external {
        Campaign memory campaign = graph.getCampaign(bytes32(ev.campaignId));
        campaign.totalRewards -= ev.amount;
        campaign.status = "INACTIVE";
        graph.saveCampaign(campaign);
    }
    
    function onTotalRewardsClaimed(EventDetails memory details, TotalRewardsClaimedEvent memory ev) external {
        Player memory player = graph.getPlayer(ev.user);
        player.id = ev.user;
        player.totalClaimedRewards += ev.totalAmount;
        graph.savePlayer(player);
    }
    
    function onTokenWhitelisted(EventDetails memory details, TokenWhitelistedEvent memory ev) external {
        IERC20 token = IERC20(ev.token);
        
        // Default values in case calls fail
        string memory name = "";
        string memory symbol = "";
        uint8 decimals = 18; // Common default
        uint256 supply = 0;

        // Try to fetch each value separately
        try token.name() returns (string memory n) {
            name = n;
        } catch {}

        try token.symbol() returns (string memory s) {
            symbol = s;
        } catch {}

        try token.decimals() returns (uint8 d) {
            decimals = d;
        } catch {}

        try token.totalSupply() returns (uint256 ts) {
            supply = ts;
        } catch {}

        // Save token with fetched or default values
        graph.saveLPToken(LPToken({
            id: ev.token,
            name: name,
            symbol: symbol,
            decimals: decimals,
            totalSupply: supply
        }));
    }
    
    function onTokenWhitelistRemoved(EventDetails memory details, TokenWhitelistRemovedEvent memory ev) external {
        LPToken memory token = graph.getLPToken(ev.token);
        // You might want to add a status field to LPToken if you need to track this
        graph.saveLPToken(token);
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
        bytes32 claimId = bytes32(details.uniqueId());
        
        // Create reward claim record
        RewardClaim memory claim = graph.getRewardClaim(claimId);
        claim.id = claimId;
        claim.playerId = ev.user;
        claim.campaignId = bytes32(ev.campaignId);
        claim.amount = ev.amount;
        claim.timestamp = details.timestamp;
        claim.transactionHash = details.transactionHash;
        graph.saveRewardClaim(claim);

        // Update campaign claimed rewards
        Campaign memory campaign = graph.getCampaign(bytes32(ev.campaignId));
        campaign.claimedRewards += ev.amount;
        graph.saveCampaign(campaign);

        // Update player stats
        Player memory player = graph.getPlayer(ev.user);
        player.id = ev.user;
        player.totalClaimedRewards += ev.amount;
        graph.savePlayer(player);

        // Update player campaign relationship
        bytes32 playerCampaignId = bytes32(uint256(keccak256(abi.encodePacked(ev.user, ev.campaignId))));
        PlayerCampaign memory playerCampaign = graph.getPlayerCampaign(playerCampaignId);
        playerCampaign.id = playerCampaignId;
        playerCampaign.playerId = ev.user;
        playerCampaign.campaignId = bytes32(ev.campaignId);
        playerCampaign.claimedRewards += ev.amount;
        playerCampaign.lastUpdated = details.timestamp;
        graph.savePlayerCampaign(playerCampaign);
    }
    
    function onRewardTokensWithdrawn(EventDetails memory details, RewardTokensWithdrawnEvent memory ev) external {
        Campaign memory campaign = graph.getCampaign(bytes32(ev.campaignId));
        campaign.totalRewards -= ev.amount;
        graph.saveCampaign(campaign);
    }
    
    function onRewardTokensDeposited(EventDetails memory details, RewardTokensDepositedEvent memory ev) external {
        Campaign memory campaign = graph.getCampaign(bytes32(ev.campaignId));
        campaign.totalRewards += ev.amount;
        graph.saveCampaign(campaign);
    }
    
    // Add this helper function to calculate rank and total players
    function _calculateRankStats(address lpTokenId, uint256 targetBalance) internal returns (uint256 rank, uint256 totalPlayers) {
        // Get all holdings for this LP token
        PlayerLPTokenHolding[] memory holdings = graph.getPlayerLPTokenHoldingsByToken(lpTokenId);
        
        // Count total players with non-zero balance
        totalPlayers = 0;
        uint256 playersAbove = 0;
        
        for (uint256 i = 0; i < holdings.length; i++) {
            if (holdings[i].balance > 0) {
                totalPlayers++;
                // Count how many players have higher balance
                if (holdings[i].balance > targetBalance) {
                    playersAbove++;
                }
            }
        }
        
        // Rank is playersAbove + 1 (1-based ranking)
        rank = playersAbove + 1;
        
        return (rank, totalPlayers);
    }

    function onReferralMade(EventDetails memory details, ReferralMadeEvent memory ev) external {
        // Update referrer's LP token holding
        bytes32 holdingId = bytes32(uint256(keccak256(abi.encodePacked(ev.referrer, ev.lpTokenAmount))));
        PlayerLPTokenHolding memory holding = graph.getPlayerLPTokenHolding(holdingId);
        holding.id = holdingId;
        holding.playerId = ev.referrer;
        holding.lpTokenId = ev.lpToken; // Make sure this is available in the event
        holding.balance += ev.lpTokenAmount;
        graph.savePlayerLPTokenHolding(holding);

        // Calculate rank and total players
        (uint256 rank, uint256 totalPlayers) = _calculateRankStats(holding.lpTokenId, holding.balance);

        // Create balance snapshot
        bytes32 snapshotId = bytes32(uint256(keccak256(abi.encodePacked(ev.referrer, details.block))));
        BalanceSnapshot memory snapshot = graph.getBalanceSnapshot(snapshotId);
        snapshot.id = snapshotId;
        snapshot.playerId = ev.referrer;
        snapshot.lpTokenId = holding.lpTokenId;
        snapshot.balance = holding.balance;
        snapshot.blockNumber = details.block;
        snapshot.timestamp = details.timestamp;
        snapshot.holdingId = holdingId;
        snapshot.rank = rank;
        snapshot.totalPlayers = totalPlayers;
        graph.saveBalanceSnapshot(snapshot);
    }
    
    function onReferralFailed(EventDetails memory details, ReferralFailedEvent memory ev) external {
        // This event is mainly for monitoring/alerting purposes
        // No state changes needed based on current schema
    }
    
    function onPaused(EventDetails memory details, PausedEvent memory ev) external {
        // Track system state
        SystemState memory state = graph.getSystemState("GLOBAL");
        state.isPaused = true;
        state.lastPausedAt = details.timestamp;
        state.lastPausedTx = details.transactionHash;
        graph.saveSystemState(state);
    }
    
    function onMinLpTokenAmountUpdated(EventDetails memory details, MinLpTokenAmountUpdatedEvent memory ev) external {
        LPToken memory token = graph.getLPToken(ev.lpToken);
        // If you need to track minimum amounts, you'd need to add this field to your LPToken schema
        graph.saveLPToken(token);
    }
    
    function onMaxRewardRateIncreased(EventDetails memory details, MaxRewardRateIncreasedEvent memory ev) external {
        Campaign memory campaign = graph.getCampaign(bytes32(ev.campaignId));
        campaign.maxRewardRate = ev.newMaxRate;
        graph.saveCampaign(campaign);
    }
    
    function onGlobalRootUpdated(EventDetails memory details, GlobalRootUpdatedEvent memory ev) external {
        // This is a system-level event that might not need persistent storage
        // If you need to track this, you might want to add a SystemState entity to your schema
    }
    
    function onChangeProposed(EventDetails memory details, ChangeProposedEvent memory ev) external {
        // This is a governance event that might not need persistent storage
        // If you need to track this, you might want to add a ProposedChange entity to your schema
    }
    
    function onChangeExecuted(EventDetails memory details, ChangeExecutedEvent memory ev) external {
        // This is a governance event that might not need persistent storage
        // If you need to track this, you might want to add a SystemConfig entity to your schema
    }
    
    function onCampaignCreated(EventDetails memory details, CampaignCreatedEvent memory ev) external {
        bytes32 campaignId = bytes32(ev.campaignId);
        Campaign memory campaign = graph.getCampaign(campaignId);
        campaign.id = campaignId;
        campaign.creator = ev.creator;
        campaign.rewardToken = ev.rewardToken;
        campaign.lpTokenId = ev.lpToken;
        campaign.maxRewardRate = ev.maxRewardRate;
        campaign.startTimestamp = ev.startTimestamp;
        campaign.endTimestamp = ev.endTimestamp;
        campaign.totalRewards = ev.totalRewards;
        campaign.claimedRewards = 0;
        campaign.status = "ACTIVE";
        graph.saveCampaign(campaign);
    }
}