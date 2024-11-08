/** AUTOGENERATED CODE BY GHOSTGRAPH CODEGEN **/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

struct Player {
    address id;
    uint256 totalCumulativeRewards;
    uint256 totalClaimedRewards;
    uint256 totalPendingRewards;
}

struct LPToken {
    address id;
    string name;
    string symbol;
    uint8 decimals;
    uint256 totalSupply;
}

struct PlayerLPTokenHolding {
    bytes32 id;
    address playerId;
    address lpTokenId;
    uint256 balance;
    uint256 cumulativeRewards;
    uint256 claimedRewards;
    uint256 pendingRewards;
}

struct Campaign {
    bytes32 id;
    address creator;
    address rewardToken;
    address lpTokenId;
    uint256 maxRewardRate;
    uint256 startTimestamp;
    uint256 endTimestamp;
    uint256 totalRewards;
    uint256 claimedRewards;
    string status;
}

struct PlayerCampaign {
    bytes32 id;
    address playerId;
    bytes32 campaignId;
    uint256 cumulativeRewards;
    uint256 claimedRewards;
    uint256 pendingRewards;
    uint256 lastUpdated;
}

struct RewardClaim {
    bytes32 id;
    address playerId;
    bytes32 campaignId;
    uint256 amount;
    uint256 timestamp;
    bytes32 transactionHash;
}

struct BalanceSnapshot {
    bytes32 id;
    address playerId;
    address lpTokenId;
    bytes32 holdingId;
    uint256 balance;
    uint256 blockNumber;
    uint256 timestamp;
    uint256 rank;
    uint256 totalPlayers;
}