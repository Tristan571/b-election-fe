// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

error notOwner();

contract VotingManager {
    struct VotingInstance {
        address instanceAddress;
        string name;
    }

    address latestVotingInstance;
    mapping(address => VotingInstance) public votingInstances;
    mapping(string => bool) public usedNames; // Track used names

    // To create a new voting instance
    function createVoting(string memory _name) external {
        require(!usedNames[_name], "Name already in use"); // Check if name is already in use
        Voting voting = new Voting(msg.sender);
        votingInstances[address(voting)] = VotingInstance(
            address(voting),
            _name
        );
        latestVotingInstance = address(voting);
        usedNames[_name] = true; // Mark the name as used
    }

    function getLatestVoting() public view returns (address) {
        return latestVotingInstance;
    }
}

contract Voting {
    address immutable contractOwner;
    bool public votingActive; //if true, voting is active and available to add candidate and vote

    constructor(address creator) {
        contractOwner = creator;
        votingActive = true;
    }

    struct Voter {
        bool voted;
        uint256 votedForCandidateId;
    }
    struct Candidate {
        string name;
        address userAddress;
        string img;
        uint256 voteCount;
    }

    uint256 numOfCandidates;

    uint256 numofVoters;

    // Define a mapping to keep track of voters
    mapping(address => Voter) voters;

    address[] voterAddresses;

    Candidate[] candidates;

    function getOwner() public view returns (address) {
        return contractOwner;
    }
    

    function getvoterList() public view returns (address[] memory) {
        return voterAddresses;
    }

    /**
     * @dev This function is for adding a new candidate to the list of candidates
     * @param _name The name of the candidate to be added
     * @param _img The image of the candidate to be added
     * Requirements:
     * - The candidate with the provided name must not already exist in the list of candidates
     * Modifiers:
     * - onlyOwner: Caller must be the owner of the contract
     * - votingAvailable: Voting must be active and available to add a candidate
     */
    function addCandidate(string memory _name, string memory _img, address _userAddress)
    public
    onlyOwner
    votingAvailable
{
    // Check if the candidate with the provided userAddress already exists
    for (uint256 i = 0; i < candidates.length; i++) {
        require(
            candidates[i].userAddress != _userAddress,
            "Candidate with this address already exists"
        );
    }
    numOfCandidates = numOfCandidates + 1;

    // If the candidate is unique, add it to the candidates array
    candidates.push(Candidate({name: _name, userAddress: _userAddress, voteCount: 0, img: _img}));
}


    /**
     * Return a list of address of voters for the candidate id
     */
    function getVotersForCandidate(uint256 _candidateId)
        public
        view
        returns (address[] memory)
    {
        require(_candidateId < candidates.length, "Invalid candidate ID");

        address[] memory votersList = new address[](voterAddresses.length);
        uint256 count = 0;
        for (uint256 i = 0; i < voterAddresses.length; i++) {
            if (voters[voterAddresses[i]].votedForCandidateId == _candidateId) {
                votersList[count] = voterAddresses[i];
                count++;
            }
        }

        // Resize the array to remove any unused elements
        assembly {
            mstore(votersList, count)
        }

        // Return the array of voter addresses for the specified candidate
        return votersList;
    }

    //Vote function
    function voteFor(uint256 _candidateId) public votingAvailable {
        // Check if the voter has already voted
        require(!voters[msg.sender].voted, "You have already voted");

        // Ensure that the candidate ID is valid
        require(_candidateId < candidates.length, "Invalid candidate ID");

        // Increment the vote count for the selected candidate
        candidates[_candidateId].voteCount++;

        voterAddresses.push(msg.sender);

        // Mark the voter as voted
        voters[msg.sender].voted = true;
        numofVoters++;
    }

    function checkVoter(address _voterAddress)
        public
        view
        returns (bool, int256)
    {
        // Return a tuple containing the voter's vote status and the candidate ID they voted for
        if (voters[_voterAddress].voted) {
            return (true, int256(voters[_voterAddress].votedForCandidateId));
        } else {
            return (false, -1);
        }
    }

    function getOneCandidateById(uint256 _candidateId)
        public
        view
        returns (
           Candidate  memory
        )
    {
        

        return (candidates[_candidateId]);
    }

    //This function return a list of candidates with their id and vote counts

    function getAllCandidate() public view returns (Candidate[] memory) {
        return candidates;
    }

    function getWinningCandidate() public view returns (Candidate memory) {
        require(candidates.length > 0, "No candidates registered");

        uint256 maxVotes = 0;
        uint256 winningCandidateIndex;

        // Iterate through all candidates to find the one with the highest vote count
        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winningCandidateIndex = i;
            }
        }

        // Return the name of the winning candidate
        return candidates[winningCandidateIndex];
    }

    function getWinningCandidates() public view returns (Candidate[] memory) {
    require(candidates.length > 0, "No candidates registered");

    uint256 maxVotes = 0;
    uint256 winningCandidateCount = 0;

    // Find the maximum vote count and count the number of winning candidates
    for (uint256 i = 0; i < candidates.length; i++) {
        if (candidates[i].voteCount > maxVotes) {
            maxVotes = candidates[i].voteCount;
            winningCandidateCount = 1; // Reset the count for new maximum vote count
        } else if (candidates[i].voteCount == maxVotes) {
            winningCandidateCount++; // Increment count for candidates with the same maximum vote count
        }
    }

    // Initialize an array to store winning candidates
    Candidate[] memory winningCandidates = new Candidate[](winningCandidateCount);
    uint256 index = 0;

    // Populate the array with winning candidates
    for (uint256 i = 0; i < candidates.length; i++) {
        if (candidates[i].voteCount == maxVotes) {
            winningCandidates[index] = candidates[i];
            index++;
        }
    }

    // Return the array of winning candidates
    return winningCandidates;
}

    function endVoting() public onlyOwner {
        votingActive = false; //voting is false and the contract cannot be added candidate and vote
    }

    function getVotingStatus() public view returns (bool) {
        return votingActive;
    }

    modifier onlyOwner() {
        require(msg.sender == contractOwner, "Sender is not owner!"); // this line first then the rest of the code
        // if(msg.sender != contractOwner) {revert notOwner();}
        _;
    }

    modifier votingAvailable() {
        require(votingActive == true, "Voting has ended!");
        _;
    }
}
