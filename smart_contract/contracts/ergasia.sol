// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Election {

    struct Candidate {
        uint id;                            // proposal unique ID
        string name;                        // candidate name (up to 32 bytes)
        uint votes;                         // number of accumulated votes
    }

    struct PollingStation {
        uint id;                            // unique ID for each polling station
        string name;                        // name of polling station
        uint votersRegistered;              // how many ppl are registered in each polling station
        uint votesCasted;                   // how many ppl -> votes (1:1) casted on each polling station
    }

    struct Voter {
        bool isEnrolled;                    // whether voter is registered to a polling station
        bool hasVoted;                      // whether voter casted his vote 
        uint choice;                        // voter's choice
        uint enrolledPollingStationID;      // the polling station in which voter is registered in
        uint votedPollingStationID;         // the polling station in which voter voted
    }

    address public electionOwner;
    uint public candidatesCount;               // number of candidates
    uint public pollingStationCount;           // number of polling stations
    uint public totalRegisteredVoters;
    uint private countResult = 0;           // private variable for final results
    uint public finalResult = 0;            // public variable for final results
    uint public totalVotes = 0;
         
    mapping(uint => Candidate) public candidates;   // list of candidates
    mapping(uint => PollingStation) public pollingStations;   // list of candidates
    mapping(address => Voter) public voterRegistry;
    mapping(address => bool) public voters;
    
    enum State { Created, Voting, Ended }
    State public state;

    modifier Owner() {
        require(msg.sender == electionOwner);
        _;
    }

    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    constructor() {
        electionOwner = msg.sender;

        //  Init number of candidates
        initCandidates();

        //  Init number of polling stations
        initPollingStations();

        // set the phase of ballot
        state = State.Created;  
    }

    /** 
    * @dev Initialize candidate list
    */
    function initCandidates() internal {
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
        addCandidate("Candidate 3");
        addCandidate("Candidate 4");
        addCandidate("Candidate 5");
    }

    /** 
    * @dev Helper method to add candidates to candidate list
    * @param _name name of candidate
    */
    function addCandidate (string memory _name) private {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    /** 
    * @dev Initialize polling stations
    */
    function initPollingStations() internal {
        addPollingStation("Polling Station 1");
        addPollingStation("Polling Station 2");
        addPollingStation("Polling Station 3");
        addPollingStation("Polling Station 4");
        addPollingStation("Polling Station 5");
        addPollingStation("Polling Station 6");
        addPollingStation("Polling Station 7");
        addPollingStation("Polling Station 8");
        addPollingStation("Polling Station 9");
        addPollingStation("Polling Station 10");
    }

    /** 
    * @dev Helper method to add a polling station to list
    * @param _name name of polling station
    */
    function addPollingStation (string memory _name) private {
        pollingStationCount++;
        pollingStations[pollingStationCount] = PollingStation(pollingStationCount, _name, 0, 0);
    }

    /** 
    * @dev Adds a voter to the voter registry. May only be called by 'owner'.
    * @param _voterAddress address of voter
    * @param _pollingStationID polling station ID in which voter is registered.
    */
    function addVoter(address _voterAddress, uint _pollingStationID) public inState(State.Created) Owner {
        //  Checks whether a voter is already registered
        require(voterRegistry[_voterAddress].isEnrolled == false, "Voter is already registered.");
        // require(voterRegistry[_voterAddress].indexProposal == 0, "Voter is already registered.");

        //  Checks whether a valid polling station ID is provided. Valid range is betwenn 1 to 10.
        require(_pollingStationID >=1 && _pollingStationID <= pollingStationCount, "Please provide a valid polling station ID.");

        Voter memory v;
        v.isEnrolled = true;
        v.hasVoted = false;
        v.choice = 0;
        v.enrolledPollingStationID = _pollingStationID;
        v.votedPollingStationID = 0;
        voterRegistry[_voterAddress] = v;
        registerAtPollingStation(_pollingStationID);
        totalRegisteredVoters++;
    }

    /** 
    * @dev Helper method to count registered voter per polling station.
    * @param _stationID polling station ID.
    */
    function registerAtPollingStation(uint _stationID) internal {
        for (uint i = 1; i <= pollingStationCount; i++) {
            if (pollingStations[i].id == _stationID) {
                pollingStations[i].votersRegistered++;
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

    function castVote(uint _choice, uint _pollingStationID) public inState(State.Voting) returns (bool voted){
      
        bool found = false;

        if (voterRegistry[msg.sender].isEnrolled && !voterRegistry[msg.sender].hasVoted) {

            voterRegistry[msg.sender].choice = _choice;
            voterRegistry[msg.sender].votedPollingStationID = _pollingStationID;
            voterRegistry[msg.sender].hasVoted = true;

            pollingStations[_pollingStationID].votesCasted++;

            candidates[_choice].votes++;

            totalVotes++;
            found = true;
        }

        // if (bytes(voterRegister[msg.sender].voterName).length != 0 
        // && !voterRegister[msg.sender].voted) {
        //     voterRegister[msg.sender].voted = true;
        //     vote memory v;
        //     v.voterAddress = msg.sender;
        //     v.choice = _choice;

        //     if (_choice) {
        //         countResult++;
        //     }
        //     votes[totalVote] = v;
        //     totalVote++;
        //     found = true;
        // }

        return found;
    }

    // function endVote() public inState(State.Voting) Owner { 
    //     state = State.Ended;
    //     finalResult = countResult;
    // }
}