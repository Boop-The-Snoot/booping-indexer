// Entity 1: Player
struct Player {
    address id;
    uint256 totalCumulativeRewards;
    uint256 totalClaimedRewards;
    uint256 totalPendingRewards;
    @many(PlayerLPTokenHolding.playerId) lpTokenHoldings;
    @many(BalanceSnapshot.playerId) balanceSnapshots;
}

// Entity 2: LPToken
struct LPToken {
    address id;
    string name;
    string symbol;
    uint8 decimals;
    uint256 totalSupply;
    @many(PlayerLPTokenHolding.lpTokenId) players;
    @many(Campaign.lpTokenId) campaigns;
    @many(BalanceSnapshot.lpTokenId) balanceSnapshots;
}

// Entity 3: PlayerLPTokenHolding
struct PlayerLPTokenHolding {
    bytes32 id; // Composite ID (playerID + lpTokenID)
    @belongsTo(Player.id) playerId;
    @belongsTo(LPToken.id) lpTokenId;
    uint256 balance;
    uint256 cumulativeRewards;
    uint256 claimedRewards;
    uint256 pendingRewards;
    @many(BalanceSnapshot.holdingId) balanceSnapshots;
}

// Entity 4: Campaign
struct Campaign {
    bytes32 id; // Unique campaign identifier
    address creator;
    address rewardToken;
    @belongsTo(LPToken.id) lpTokenId;
    uint256 maxRewardRate;
    uint256 startTimestamp;
    uint256 endTimestamp;
    uint256 totalRewards;
    uint256 claimedRewards;
    string status; // "ACTIVE" or "INACTIVE"
    @many(PlayerCampaign.campaignId) players;
}

// Entity 5: PlayerCampaign
struct PlayerCampaign {
    bytes32 id; // Composite ID (playerID + campaignID)
    @belongsTo(Player.id) playerId;
    @belongsTo(Campaign.id) campaignId;
    uint256 cumulativeRewards;
    uint256 claimedRewards;
    uint256 pendingRewards;
    uint256 lastUpdated;
}

// Entity 6: RewardClaim
struct RewardClaim {
    bytes32 id; // Unique identifier (transaction hash)
    @belongsTo(Player.id) playerId;
    @belongsTo(Campaign.id) campaignId;
    uint256 amount;
    uint256 timestamp;
    bytes32 transactionHash;
}

// Entity 7: BalanceSnapshot
struct BalanceSnapshot {
    bytes32 id; // Composite ID (playerID + lpTokenID + blockNumber)
    @belongsTo(Player.id) playerId;
    @belongsTo(LPToken.id) lpTokenId;
    @belongsTo(PlayerLPTokenHolding.id) holdingId;
    uint256 balance;
    uint256 blockNumber;
    uint256 timestamp;
    uint256 rank;
    uint256 totalPlayers;
}
