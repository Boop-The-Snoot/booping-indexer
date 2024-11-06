// SPDX-License-Identifier: Business Source License 1.1

pragma solidity ^0.8.28;

interface Events {
	event Unpaused(address account);
	event UnclaimedRewardsWithdrawn(uint256 indexed campaignId, uint256 amount, address indexed recipient);
	event TotalRewardsClaimed(address indexed user, uint256 totalAmount);
	event TokenWhitelisted(address indexed token);
	event TokenWhitelistRemoved(address indexed token);
	event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
	event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
	event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
	event RewardsClaimed(address indexed user, uint256 indexed campaignId, uint256 amount);
	event RewardTokensWithdrawn(uint256 indexed campaignId, address indexed recipient, uint256 amount);
	event RewardTokensDeposited(uint256 indexed campaignId, address indexed depositor, uint256 amount);
	event ReferralMade(address indexed referrer, address indexed referee, uint256 lpTokenAmount);
	event ReferralFailed(address indexed referrer, address indexed referee, string reason);
	event Paused(address account);
	event MinLpTokenAmountUpdated(address indexed lpToken, uint256 amount);
	event MaxRewardRateIncreased(uint256 indexed campaignId, uint256 newMaxRate);
	event GlobalRootUpdated(bytes32 newRoot, uint256 updateTimestamp);
	event ChangeProposed(string changeType, uint256 newValue, uint256 effectiveTime);
	event ChangeExecuted(string changeType, uint256 newValue);
	event CampaignCreated(uint256 indexed campaignId, address indexed creator, address rewardToken, address lpToken, uint256 maxRewardRate, uint256 startTimestamp, uint256 endTimestamp, uint256 totalRewards);
}