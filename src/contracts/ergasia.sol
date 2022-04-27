// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Ballot {

    struct Voter {
        bool enrolled;                      // whether voter is registered to a polling station
        bool voted;                         // whether voter casted his vote 
        int indexProposal;                  // voter's choice
        uint enrolledPollingStationID;      // the polling station in which voter is registered in
        uint votedPollingStationID;         // the polling station in which voter voted
    }

    struct Proposal {
        uint id;                            // proposal unique ID
        bytes32 name;                       // candidate name (up to 32 bytes)
        uint voteCount;                     // number of accumulated votes
    }

    struct PollingStation {
        uint stationID;                     // unique ID for each polling station
        uint pplEnrolled;                   // how many ppl are registered in each polling station
        uint votesCasted;                   // how many ppl -> votes (1:1) casted on each polling station
    }

    address public ballotOwner;

    uint numOfCandidates = 5;               // number of candidates
    uint numOfPollingStations = 10;         // amount of different polling stations
    uint private countResult = 0;           // private variable for final results
    uint public finalResult = 0;            // public variable for final results
    uint public totalVoters = 0;
    uint public totalVotes = 0;

    Proposal[] public proposals;            // list of candidates
    PollingStation[] public stations;       // voting centers

    mapping(address => Voter) public voterRegister;

    enum State { Created, Voting, Ended }
    State public state;

    modifier Owner() {
        require(msg.sender == ballotOwner);
        _;
    }

    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    constructor() {
        ballotOwner = msg.sender;

        //  Init number of candidates
        initCandidates();
        //  Init number of polling stations
        initPollingStations(numOfPollingStations);
        // set the phase of ballot
        state = State.Created;  
    }

    /*
    * @dev Initialize candidated.
    * @param -
    */
    function initCandidates() internal {

        bytes32[] memory proposalNames = new bytes32[](numOfCandidates);
        proposalNames[0] = 0x43616e6469646174652031000000000000000000000000000000000000000000;  // Candidate 1
        proposalNames[1] = 0x43616e6469646174652032000000000000000000000000000000000000000000;  // Candidate 2
        proposalNames[2] = 0x43616e6469646174652033000000000000000000000000000000000000000000;  // Candidate 3
        proposalNames[3] = 0x43616e6469646174652034000000000000000000000000000000000000000000;  // Candidate 4
        proposalNames[4] = 0x43616e6469646174652035000000000000000000000000000000000000000000;  // Candidate 5


        for (uint i = 0; i < proposalNames.length; i++) {
            uint counter = i + 1;

            proposals.push(Proposal({
                id: counter,
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    /** 
    * @dev Initialize polling stations
    * @param amount number of polling stations available
    */
    function initPollingStations(uint amount) internal {
        for (uint i = 0; i < amount; i++) {
            stations.push(PollingStation({
                stationID: (i+1),   // IDs range from 1 to 10
                pplEnrolled: 0,
                votesCasted: 0            
            }));
        }
    }

    /** 
    * @dev Adds a voter to the voter registry. May only be called by 'owner'.
    * @param _voterAddress address of voter
    * @param _pollingStationID polling station ID in which voter is registered.
    */
    function addVoter(address _voterAddress, uint _pollingStationID) public inState(State.Created) Owner {
        //  Checks whether a voter is already registered
        require(voterRegister[_voterAddress].indexProposal == 0, "Voter is already registered.");
        //  Checks whether a valid polling station ID is provided. Valid range is betwenn 1 to 10.
        require(_pollingStationID >=1 && _pollingStationID <= numOfPollingStations, "Please provide a valid polling station ID.");

        Voter memory v;
        v.enrolled = true;
        v.voted = false;
        v.indexProposal = -1;
        v.enrolledPollingStationID = _pollingStationID;
        v.votedPollingStationID = 0;
        voterRegister[_voterAddress] = v;
        totalVoters++;

        registerAtPollingStation(_pollingStationID);
    }

    /** 
    * @dev Helper method to count registered voter per polling station.
    * @param _stationID polling station ID.
    */
    function registerAtPollingStation(uint _stationID) internal {
        for (uint i = 0; i < stations.length; i++) {
            if (stations[i].stationID == _stationID) {
                stations[i].pplEnrolled++;
                break;
            }
        }
    }

    /*
    * @dev Voting process begins. Can only be called by 'owner' when ballot has been created.
    * @param -
    */
    function startVote() public inState(State.Created) Owner {
        state = State.Voting;
    }

    // function castVote(bool _choice, uint _votedPollingStationID) public inState(State.Voting) returns (bool voted){

    //     bool found = false;

    //     if (bytes(voterRegister[msg.sender].voterName).length != 0 
    //     && !voterRegister[msg.sender].voted) {
    //         voterRegister[msg.sender].voted = true;
    //         vote memory v;
    //         v.voterAddress = msg.sender;
    //         v.choice = _choice;

    //         if (_choice) {
    //             countResult++;
    //         }
    //         votes[totalVote] = v;
    //         totalVote++;
    //         found = true;
    //     }

    //     return found;
    // }

    // function endVote() public inState(State.Voting) Owner { 
    //     state = State.Ended;
    //     finalResult = countResult;
    // }
}