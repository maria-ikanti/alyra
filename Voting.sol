DEPLOY & RUN TRANSACTIONS
ENVIRONMENT

Remix VM (Shanghai)
VM
ACCOUNT

GAS LIMIT
VALUE

CONTRACT

evm version: shanghai
Deploy

Publish to IPFS
At Address

Transactions recorded
21
Run transactions using the latest compilation result
Save
Run
Deployed Contracts
VOTING AT 0XF5E...177AB (MEMORY)
Balance: 0. ETH
countVote
endVote
registerProposalsByOwner

registerProposalsByVoter
proposalDesctiptions:

Calldata
Parameters
transact
registerVoters

renounceOwnership
startProposalsSession
startVote
transferOwnership

vote

whiteListVoter

checkVotersProposal

compare

getWinner
getWinnerProposalDesc
owner
Low level interactions
CALLDATA
Transact


57585960616263646566676869707172737475767778798081828384858687888990919293949596979899100101102103104105106107108109110111112
    /*    * Init voters    * L'administrateur du vote enregistre une liste blanche d'électeurs identifiés par leur adresse Ethereum.    */    function registerVoters(address[] memory _voters) external onlyOwner { infinite gas         for (uint i = 0; i < _voters.length; i++) {            // for has voted and itProposal we have default values. No need to set them            votersWhitelist[_voters[i]].isRegistered = true;            emit VoterRegistered(_voters[i]);        }    }    /*    * L'administrateur du vote commence la session d'enregistrement de la proposition.    */    function startProposalsSession() external onlyOwner { infinite gas        changeWorkflowStatus(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);    }        /*    * Init proposals array for  all voters    * Le vote peut porter sur un nombre potentiellement important de propositions suggérées de manière dynamique par les électeurs eux-mêmes.    * Les électeurs inscrits sont autorisés à enregistrer leurs propositions pendant que la session d'enregistrement est active.    */    function registerProposalsByVoter(string[] memory proposalDesctiptions) external { infinite gas        // Check if msg.sender is whitelisted and we have the right workflow state        if(currentStatusId == WorkflowStatus.ProposalsRegistrationStarted && isWhitelisted(msg.sender)){            for (uint i = 0; i < proposalDesctiptions.length; i++) {                proposals.push(Proposal({                    description: proposalDesctiptions[i],                    voteCount: 0                }));                // Send the ProposalRegistered event taking the current proposals lenght -1 as index            emit ProposalRegistered(proposals.length-1);            }            }else{            revert VoterNotAllowed(msg.sender);        }    }    /*    * L'administrateur de vote met fin à la session d'enregistrement des propositions.    * L'administrateur du vote commence la session de vote.    */    function startVote() external  onlyOwner{ infinite gas        changeWorkflowStatus(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);    }    /*     * Les électeurs inscrits votent pour leur proposition préférée.    * They send the proposal description     */    function vote(string calldata _proposalDesc) external { infinite gas        require (currentStatusId==WorkflowStatus.VotingSessionStarted, "Votung is not allowed yet");

? of 7
0
listen on all transactions

 Welcome to Remix 0.42.0 

Your files are stored in indexedDB, 68.17 KB / 4.77 MB used

You can use this terminal to: 
Check transactions details and start debugging.
Execute JavaScript scripts:
 - Input a script directly in the command line interface 
 - Select a Javascript file in the file explorer and then run `remix.execute()` or `remix.exeCurrent()`  in the command line interface 
 - Right click on a JavaScript file in the file explorer and then click `Run` 
The following libraries are accessible:
web3.js
ethers.js 
gpt <your question here>  
Type the library name to see available commands.
creation of Voting pending...
[vm]from: 0x787...cabaBto: Voting.(constructor)value: 0 weidata: 0x608...80033logs: 1hash: 0x7ff...24b9d
Debug
status	0x1 Transaction mined and execution succeed
transaction hash	0x7ff864edc229bc72c27fd26f5ed770d36c86adac07b4c2eb3b2249e3c4f24b9d
block hash	0x5787e9df92c3c5ec17ba7f1b0f1827e599a51be362b3402126070af9f27ee1ec
block number	1
contract address	0x99CF4c4CAE3bA61754Abd22A8de7e8c7ba3C196d
from	0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
to	Voting.(constructor)
gas	1884562 gas
transaction cost	1639229 gas 
execution cost	1469253 gas 
input	0x608...80033
decoded input	{}
decoded output	 - 
logs	[
	{
		"from": "0x99CF4c4CAE3bA61754Abd22A8de7e8c7ba3C196d",
		"topic": "0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0",
		"event": "OwnershipTransferred",
		"args": {
			"0": "0x0000000000000000000000000000000000000000",
			"1": "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB",
			"previousOwner": "0x0000000000000000000000000000000000000000",
			"newOwner": "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB"
		}
	}
]
transact to Voting.registerVoters errored: Error encoding arguments: Error: expected array value (argument=null, value="", code=INVALID_ARGUMENT, version=abi/5.7.0)
transact to Voting.registerVoters errored: Error encoding arguments: Error: expected array value (argument=null, value="0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", code=INVALID_ARGUMENT, version=abi/5.7.0)
transact to Voting.registerProposalsByVoter errored: Error encoding arguments: Error: expected array value (argument=null, value="", code=INVALID_ARGUMENT, version=abi/5.7.0)
transact to Voting.startVoting pending ... 
transact to Voting.startVoting errored: Error occured: revert.

revert
	The transaction has been reverted to the initial state.
Error provided by the contract:
StatusNotAllowed
Parameters:
{
 "_previous": {
  "value": "1"
 },
 "_next": {
  "value": "3"
 }
}
Debug the transaction to get more information.
[vm]from: 0x787...cabaBto: Voting.startVoting() 0x99C...C196dvalue: 0 weidata: 0x1ec...6b60alogs: 0hash: 0xdad...e0945
Debug
status	0x0 Transaction mined but execution failed
transaction hash	0xdadd8c2f7c7b644d164bfe55cf61298cebcbe4d460960ed925ce4d6be63e0945
block hash	0xc083c4833cacec78cfe89039c6695f7788e4d534a1a871458507da148135a7db
block number	2
from	0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
to	Voting.startVoting() 0x99CF4c4CAE3bA61754Abd22A8de7e8c7ba3C196d
gas	3000000 gas
transaction cost	24631 gas 
execution cost	3567 gas 
input	0x1ec...6b60a
decoded input	{}
decoded output	{}
logs	[]
transact to Voting.startVoting pending ... 
transact to Voting.startVoting errored: Error occured: revert.

revert
	The transaction has been reverted to the initial state.
Error provided by the contract:
StatusNotAllowed
Parameters:
{
 "_previous": {
  "value": "1"
 },
 "_next": {
  "value": "3"
 }
}
Debug the transaction to get more information.
[vm]from: 0x787...cabaBto: Voting.startVoting() 0x99C...C196dvalue: 0 weidata: 0x1ec...6b60alogs: 0hash: 0x7b4...756f5
Debug
creation of Voting pending...
[vm]from: 0x787...cabaBto: Voting.(constructor)value: 0 weidata: 0x608...80033logs: 1hash: 0x49b...33527
Debug
creation of Voting pending...
[vm]from: 0x787...cabaBto: Voting.(constructor)value: 0 weidata: 0x608...80033logs: 1hash: 0x772...ba03a
Debug
transact to Voting.countVote pending ... 
[vm]from: 0x787...cabaBto: Voting.countVote() 0x99C...C196dvalue: 0 weidata: 0x1a6...cd2fdlogs: 0hash: 0x718...a96e4
Debug
transact to Voting.endVote pending ... 
[vm]from: 0x787...cabaBto: Voting.endVote() 0x99C...C196dvalue: 0 weidata: 0xb92...23946logs: 1hash: 0x0c0...2d04c
Debug
transact to Voting.registerVoters errored: Error encoding arguments: Error: expected array value (argument=null, value="0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", code=INVALID_ARGUMENT, version=abi/5.7.0)
transact to Voting.startVoting pending ... 
transact to Voting.startVoting errored: Error occured: revert.

revert
	The transaction has been reverted to the initial state.
Error provided by the contract:
StatusNotAllowed
Parameters:
{
 "_previous": {
  "value": "1"
 },
 "_next": {
  "value": "3"
 }
}
Debug the transaction to get more information.
[vm]from: 0x787...cabaBto: Voting.startVoting() 0x99C...C196dvalue: 0 weidata: 0x1ec...6b60alogs: 0hash: 0x16d...47a73
Debug
creation of Voting pending...
[vm]from: 0x787...cabaBto: Voting.(constructor)value: 0 weidata: 0x608...80033logs: 1hash: 0x3f9...6b1ae
Debug
transact to Voting.startVoting pending ... 
transact to Voting.startVoting errored: Error occured: revert.

revert
	The transaction has been reverted to the initial state.
Error provided by the contract:
StatusNotAllowed
Parameters:
{
 "_previous": {
  "value": "1"
 },
 "_next": {
  "value": "3"
 }
}
Debug the transaction to get more information.
[vm]from: 0x787...cabaBto: Voting.startVoting() 0x99C...C196dvalue: 0 weidata: 0x1ec...6b60alogs: 0hash: 0xfa8...093b8
Debug
status	0x0 Transaction mined but execution failed
transaction hash	0xfa8501ac3005d314b738776936f6761e50b165f117ab41a83f4f5c50c71093b8
block hash	0xf9af263e4961fc5b138066893cc3a873484c6a02fb36fe87f8f04248504fe0b5
block number	10
from	0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
to	Voting.startVoting() 0x99CF4c4CAE3bA61754Abd22A8de7e8c7ba3C196d
gas	3000000 gas
transaction cost	24631 gas 
execution cost	3567 gas 
input	0x1ec...6b60a
decoded input	{}
decoded output	{}
logs	[]
creation of Voting pending...
[vm]from: 0x787...cabaBto: Voting.(constructor)value: 0 weidata: 0x608...80033logs: 1hash: 0xf1f...dcad5
Debug
creation of Voting pending...
[vm]from: 0x787...cabaBto: Voting.(constructor)value: 0 weidata: 0x608...80033logs: 1hash: 0x4f3...04e98
Debug
transact to Voting.startVote pending ... 
[vm]from: 0x787...cabaBto: Voting.startVote() 0xbd7...9EFB3value: 0 weidata: 0x4c0...a6af0logs: 1hash: 0x43c...8875e
Debug
transact to Voting.startProposalsSession pending ... 
[vm]from: 0x787...cabaBto: Voting.startProposalsSession() 0xbd7...9EFB3value: 0 weidata: 0xe47...caad3logs: 1hash: 0x5fd...74218
Debug
transact to Voting.registerProposalsByVoter errored: Error encoding arguments: Error: expected array value (argument=null, value="une proposiiton", code=INVALID_ARGUMENT, version=abi/5.7.0)
call to Voting.checkVotersProposal errored: Error encoding arguments: Error: invalid address (argument="address", value="", code=INVALID_ARGUMENT, version=address/5.7.0) (argument=null, value="", code=INVALID_ARGUMENT, version=abi/5.7.0)
call to Voting.getWinner
CALL
[call]from: 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaBto: Voting.getWinner()data: 0x8e7...ea5b2
Debug
call to Voting.getWinner errored: Error occured: revert.

revert
	The transaction has been reverted to the initial state.
Error provided by the contract:
NoWinnerYet
Parameters:
{}
Debug the transaction to get more information.
transact to Voting.endVote pending ... 
[vm]from: 0x787...cabaBto: Voting.endVote() 0xbd7...9EFB3value: 0 weidata: 0xb92...23946logs: 1hash: 0xcf3...7746e
Debug
call to Voting.getWinner
CALL
[call]from: 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaBto: Voting.getWinner()data: 0x8e7...ea5b2
Debug
call to Voting.getWinner errored: Error occured: revert.

revert
	The transaction has been reverted to the initial state.
Error provided by the contract:
NoWinnerYet
Parameters:
{}
Debug the transaction to get more information.
transact to Voting.countVote pending ... 
[vm]from: 0x787...cabaBto: Voting.countVote() 0xbd7...9EFB3value: 0 weidata: 0x1a6...cd2fdlogs: 0hash: 0xd84...97d01
Debug
transact to Voting.vote pending ... 
transact to Voting.vote errored: Error occured: revert.

revert
	The transaction has been reverted to the initial state.
Reason provided by the contract: "Votung is not allowed yet".
Debug the transaction to get more information.
[vm]from: 0x787...cabaBto: Voting.vote(string) 0xbd7...9EFB3value: 0 weidata: 0xfc3...00000logs: 0hash: 0x20a...b9535
Debug
creation of Voting pending...
[vm]from: 0x787...cabaBto: Voting.(constructor)value: 0 weidata: 0x608...80033logs: 1hash: 0xd48...bf829
Debug
transact to Voting.registerVoters errored: Error encoding arguments: Error: expected array value (argument=null, value="_voters[0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB]", code=INVALID_ARGUMENT, version=abi/5.7.0)
transact to Voting.startProposalsSession pending ... 
[vm]from: 0x787...cabaBto: Voting.startProposalsSession() 0x419...2546Fvalue: 0 weidata: 0xe47...caad3logs: 1hash: 0xcc1...2c8ea
Debug
transact to Voting.registerVoters errored: Error encoding arguments: Error: expected array value (argument=null, value="0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", code=INVALID_ARGUMENT, version=abi/5.7.0)
creation of Voting pending...
[vm]from: 0x787...cabaBto: Voting.(constructor)value: 0 weidata: 0x608...80033logs: 1hash: 0x922...ad810
Debug
transact to Voting.startProposalsSession pending ... 
[vm]from: 0x787...cabaBto: Voting.startProposalsSession() 0xF5E...177aBvalue: 0 weidata: 0xe47...caad3logs: 1hash: 0x671...9b833
Debug
transact to Voting.registerProposalsByVoter errored: Error encoding arguments: Error: expected array value (argument=null, value="proposal 1", code=INVALID_ARGUMENT, version=abi/5.7.0)
>
? of 7 found for 'returns'
