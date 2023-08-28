// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PollContract {
    address private ownerAddress;
    mapping(address => bool) private pollCreators;
    mapping(address => bool) private authorisedVoters;
    mapping(address => mapping(string => Poll)) private pollMapping;

    struct Poll {
        string description;
        address[] candidates;
        uint256[] candidatesVote;
        address[] voters;
    }

    struct PollInfo {
        string name;
        string description;
        address[] candidates;
        uint256[] votes;
    }

    constructor() {
        ownerAddress = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == ownerAddress, "Only contract owner can perform this action");
        _;
    }

    modifier authorisedPollCreator {
        require(pollCreators[msg.sender], "Only authorised Poll Creators can perform this action");
        _;
    }

    modifier hasCastedVote(address pollOwner, string memory pollName) {
        Poll storage poll = pollMapping[pollOwner][pollName];
        bool voteCasted = false;

        for (uint256 count = 0; count < poll.voters.length; count++) {
            if (poll.voters[count] == msg.sender) {
                voteCasted = true;
            }
        }

        require(!voteCasted, "You can only cast one vote");
        _;
    }

    modifier isAllowedToVote {
        require(authorisedVoters[msg.sender], "You are not authorised to cast votes");
        _;
    }

    function authorisePollCreator(address pollCreator, bool authorisation) external onlyOwner {
        pollCreators[pollCreator] = authorisation;
    }

    function authorisePollVoters(address voter, bool authorisation) external authorisedPollCreator {
        authorisedVoters[voter] = authorisation;
    }

    function getPollByCreator(address pollCreator, string memory pollName) public view returns (PollInfo memory) {
        Poll storage poll = pollMapping[pollCreator][pollName];
        return PollInfo(pollName, poll.description, poll.candidates, poll.candidatesVote);
    }

    function createPoll(string memory pollName, string memory description, address[] memory candidates) external authorisedPollCreator {
        Poll memory poll;
        poll.description = description;
        poll.candidates = candidates;
        poll.candidatesVote = new uint256[](candidates.length);
        pollMapping[msg.sender][pollName] = poll;
    }

    function listCandidatesInAPoll(address pollOwner, string memory pollName) public view authorisedPollCreator isAllowedToVote returns (address[] memory) {
        Poll storage poll = pollMapping[pollOwner][pollName];
        return poll.candidates;
    }

    function voteCandidateInPoll(address candidate, address pollOwner, string memory pollName) public hasCastedVote(pollOwner, pollName) isAllowedToVote {
        Poll storage poll = pollMapping[pollOwner][pollName];
        uint256 candidateIndex = 0;

        for (uint256 count = 0; count < poll.candidates.length; count++) {
            if (poll.candidates[count] == candidate) {
                candidateIndex = count;
                break;
            }
        }

        poll.candidatesVote[candidateIndex] = poll.candidatesVote[candidateIndex] + 1;
        poll.voters.push(msg.sender);
    }
}
