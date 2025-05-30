// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Project {
    address public owner;
    mapping(address => uint) public donations;
    uint public totalDonations;
    address[] public donors;

    struct Milestone {
        string description;
        uint targetAmount;
        bool achieved;
    }

    Milestone[] public milestones;

    event DonationReceived(address indexed donor, uint amount);
    event MilestoneAdded(uint milestoneId, string description, uint targetAmount);
    event MilestoneAchieved(uint milestoneId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Core Function 1: Donate to the charity
    function donate() external payable {
        require(msg.value > 0, "Donation must be greater than 0");
        if (donations[msg.sender] == 0) {
            donors.push(msg.sender);
        }
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;
        emit DonationReceived(msg.sender, msg.value);
    }

    // Core Function 2: Add a spending milestone (by owner)
    function addMilestone(string memory _description, uint _targetAmount) external onlyOwner {
        milestones.push(Milestone(_description, _targetAmount, false));
        emit MilestoneAdded(milestones.length - 1, _description, _targetAmount);
    }

    // Core Function 3: Mark milestone as achieved (by owner)
    function markMilestoneAchieved(uint _milestoneId) external onlyOwner {
        require(_milestoneId < milestones.length, "Invalid milestone ID");
        milestones[_milestoneId].achieved = true;
        emit MilestoneAchieved(_milestoneId);
    }

    // View all donors
    function getAllDonors() external view returns (address[] memory) {
        return donors;
    }

    // View milestone details
    function getMilestone(uint _milestoneId) external view returns (string memory, uint, bool) {
        Milestone memory m = milestones[_milestoneId];
        return (m.description, m.targetAmount, m.achieved);
    }
}
