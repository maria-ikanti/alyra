// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";

struct Voter {
bool isRegistered;
bool hasVoted;
uint votedProposalId;
}

struct Proposal {
string description;
uint voteCount;
}

enum WorkflowStatus {
RegisteringVoters,
ProposalsRegistrationStarted,
ProposalsRegistrationEnded,
VotingSessionStarted,
VotingSessionEnded,
VotesTallied,
ExAequoVoting
}

contract votingPlus is Ownable{

    // Vars
    uint private winnerProposalId;
    WorkflowStatus private currentStatusId;
    mapping(address=>Voter) private votersWhitelist;
    Proposal[] proposals;
    
    Proposal[] exaequoProposals;
        
    // Events
    event VoterRegistered(address voterAddress); 
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted (address voter, uint proposalId);

    event ExAequoVoteNeeded();

    // Errors
    error AlreadyWhitelisted(address _voter);
    error VoterNotAllowed(address _voter);
    error StatusNotAllowed(WorkflowStatus _previous, WorkflowStatus _next);
    error NoWinnerYet();
    error NoProposalFound(address _voter);

    // uses ownable constructor
     constructor() Ownable(msg.sender){
        votersWhitelist[msg.sender].isRegistered = true;
    }


// ex aequo management
// Add exaequoProposals table
// Add ExAequoVoteNeeded event
// Add ExAequoVoting to enum
// update countVote Function
// Add restartVote Function
// It should be possible to execute the restatVote as long as there are ex aqueo proposals remaining



// Voting process

    /*
    * Init voters
    * L'administrateur du vote enregistre une liste blanche d'électeurs identifiés par leur adresse Ethereum.
    */
    function registerVoters(address[] memory _voters) external onlyOwner {
         for (uint i = 0; i < _voters.length; i++) {
            // for has voted and itProposal we have default values. No need to set them
            votersWhitelist[_voters[i]].isRegistered = true;
            emit VoterRegistered(_voters[i]);
        }
    }

    /*
    * L'administrateur du vote commence la session d'enregistrement de la proposition.
    */
    function startProposalsSession() external onlyOwner {
        changeWorkflowStatus(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);
    }

    
    /*
    * Init proposals array for  all voters
    * Le vote peut porter sur un nombre potentiellement important de propositions suggérées de manière dynamique par les électeurs eux-mêmes.
    * Les électeurs inscrits sont autorisés à enregistrer leurs propositions pendant que la session d'enregistrement est active.
    */
    function registerProposalsByVoter(string[] memory proposalDesctiptions) external {
        // Check if msg.sender is whitelisted and we have the right workflow state
        if(currentStatusId == WorkflowStatus.ProposalsRegistrationStarted && isWhitelisted(msg.sender)){
            for (uint i = 0; i < proposalDesctiptions.length; i++) {
                proposals.push(Proposal({
                    description: proposalDesctiptions[i],
                    voteCount: 0
                }));
                // Send the ProposalRegistered event taking the current proposals lenght -1 as index
            emit ProposalRegistered(proposals.length-1);
            }
    
        }else{
            revert VoterNotAllowed(msg.sender);
        }
    }

    /*
    * L'administrateur de vote met fin à la session d'enregistrement des propositions.
    * L'administrateur du vote commence la session de vote.
    */
    function startVote() public  onlyOwner{
        changeWorkflowStatus(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
    }

    /* 
    * Les électeurs inscrits votent pour leur proposition préférée.
    * They send the proposal description 
    */
    function vote(string calldata _proposalDesc) external {
        require (currentStatusId==WorkflowStatus.VotingSessionStarted, "Votung is not allowed yet");
        require(isWhitelisted(msg.sender),"You're not allowed to vote");
        // we check all the proposals and if the id is the wright one, we increment its votecount
        for(uint i = 0; i < proposals.length; i++){
            if(compare(proposals[i].description,_proposalDesc)){
                proposals[i].voteCount+=1;
                emit Voted(msg.sender,i);
            }
        }
    }

    /*
    * L'administrateur du vote met fin à la session de vote.
    */
    function endVote() external onlyOwner{
        changeWorkflowStatus(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
    }

    /*
    *  L'administrateur du vote comptabilise les votes.
    *  Traitement des ex aequos
    */
    function countVote() external onlyOwner{
        uint winnerId;
        uint winnerVotesCount;
        for(uint i = 0; i < proposals.length; i++){
            if(proposals[i].voteCount>winnerVotesCount){
                winnerId=i;
                winnerVotesCount=proposals[i].voteCount;
            }
            winnerProposalId = winnerId;
            changeWorkflowStatus(WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotesTallied);
        }
        // get ex aequo votes and put them in a specific array
        for(uint i = 0; i < proposals.length; i++){
            if(proposals[i].voteCount==winnerVotesCount){
                exaequoProposals.push(proposals[i]);
            }           
        }
        // that means we have at least 2 proposals with the same vote count
        // we change the status to ExAequoVoting
        if(exaequoProposals.length>1){
            emit ExAequoVoteNeeded();
            changeWorkflowStatus(WorkflowStatus.VotesTallied, WorkflowStatus.ExAequoVoting);
        }
    }

    /*
    * Restart voting but only with ex-eaquos proposals
    */
    function restartVote() external onlyOwner{
        if(currentStatusId==WorkflowStatus.ExAequoVoting){
            delete proposals;
        // reassign to poposals array the values of the exaequoProposals only
        for(uint i = 0; i < exaequoProposals.length; i++){
            proposals[i]=exaequoProposals[i];
        }
        // Empty the exaequoProposals array for a possible future use. Not sure about the delete use
        delete exaequoProposals;
        // start a new vote again
        startVote();
        }   
    }


    /* 
    * If workflowStatus is VotesTailled, returns winningProposalID
    */
    function getWinner() public view returns(uint _winnerProposalId){
        if(currentStatusId==WorkflowStatus.VotesTallied)
            return winnerProposalId;
        else revert NoWinnerYet();
    }

    /* 
    * If workflowStatus is VotesTailled, returns winningProposalID
    */
    function getWinnerProposalDesc() public view returns(string memory _winnerProposalDesc){
        uint temp = getWinner();
        return proposals[temp].description;
    }

    
    //Tool functions
    
    /*
    * A function to reuse every time we wish chicking if a voter is whitelisted
    */
    function isWhitelisted(address _voter) private view returns(bool){
        return votersWhitelist[_voter].isRegistered;
    }

    /*
    * A function to reuse every time we need compare two strings
    */
    function compare(string memory str1, string memory str2) public pure returns (bool) {
        if (bytes(str1).length != bytes(str2).length) {
            return false;
        }
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }

    /*
    * Init proposals array by owner only
    * Le vote peut porter sur un petit nombre de propositions (ou de candidats) présélectionnées
    */
    function registerProposalsByOwner(string[] memory proposalDesctiptions) external onlyOwner {
         for (uint i = 0; i < proposalDesctiptions.length; i++) {
            proposals.push(Proposal({
                description: proposalDesctiptions[i],
                voteCount: 0
            }));
        }
    }


    /*
    * Whitelists a voter
    * Checks if the voter is already whitelisted. If so, reverts and throws an exception
    * callable only by the owner
    */
    function whiteListVoter(address _voter) external onlyOwner {
        if(!votersWhitelist[_voter].isRegistered){
            votersWhitelist[_voter].isRegistered=true;
            emit VoterRegistered(_voter);
        }
        else   {
            revert AlreadyWhitelisted(_voter);
        }
            
    }


        /*
    * The owner changes the voting workflow status
    its a private function for security reasons
    */ 
    function changeWorkflowStatus(WorkflowStatus _previousStatus, WorkflowStatus _newStatus) private onlyOwner {
        require (_previousStatus != _newStatus, "Statuses must be different");
        // check if the previous status is the one that precedes the new status by using enum indexes
        // les status doivent se suivre 
        if((uint(_previousStatus) +1) == uint(_newStatus))
        {
            currentStatusId = _newStatus;
            emit WorkflowStatusChange(_previousStatus, _newStatus);
        }else{
            revert StatusNotAllowed(_previousStatus,_newStatus);
        }
    }


    /*
    * Check someone elses's vote
    */
      function checkVotersProposal(address _voter) external view returns (uint _votedProposalId){
        // check is the caller is whitelisted and if the voter has voted
        if(isWhitelisted(msg.sender) && votersWhitelist[_voter].hasVoted){
            // gests the voter's vote id
            return votersWhitelist[_voter].votedProposalId;
        }else{
            revert NoProposalFound(_voter);
        }
      }
}
