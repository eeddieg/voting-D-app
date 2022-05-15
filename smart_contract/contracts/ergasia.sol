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
        mapping(uint => Candidate) scoresPerCandidate;
    }

    struct Voter {
        bool isEnrolled;                    // whether voter is registered to a polling station
        bool hasVoted;                      // whether voter casted his vote 
        uint choice;                        // voter's choice
        uint enrolledPollingStationID;      // the polling station in which voter is registered in
        uint votedPollingStationID;         // the polling station in which voter voted
    }

    address public electionOwner;
    uint public candidatesCount;            // number of candidates
    uint public pollingStationCount;        // number of polling stations
    uint public totalRegisteredVoters;
    uint private countResult;               // private variable for final results
    uint public finalResult;                // public variable for final results

    mapping(uint => Candidate) public candidates;               // list of candidates
    mapping(uint => Candidate[]) private candidatesPerStation;   // list of candidates
    mapping(uint => PollingStation) public pollingStations;     // list of candidates
    mapping(address => Voter) public voterRegistry;
    mapping(address => bool) public voters;
    
    enum State { Created, Started, Voting, Ended }
    State public state;

    modifier Owner() {
        require(msg.sender == electionOwner);
        _;
    }

    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    event VoteCasted(bool voted, uint _choice, uint _pollStationID);

    constructor() {
        electionOwner = msg.sender;

        //  Init number of polling stations
        initPollingStations();
        
        //  Init number of candidates
        initCandidates();

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

        for (uint i = 1; i <= pollingStationCount; i++) {
            pollingStations[i].scoresPerCandidate[candidatesCount] = Candidate(candidatesCount, _name, 0);
        }
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
        // pollingStations[pollingStationCount] = PollingStation(pollingStationCount, _name, 0, 0, candidates);
        PollingStation storage pollStation = pollingStations[pollingStationCount];
        pollStation.id = pollingStationCount;
        pollStation.name = _name;
        pollStation.votersRegistered = 0;
        pollStation.votesCasted = 0;        
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
    * @dev Voting process begins. Can only be called by 'owner' when state is created.
    */
    function startElection() public inState(State.Created) Owner {
        state = State.Started;
    }

    /*
    * @dev Voting process is running. Can only be called by 'owner' when state is started.
    */
    function startVoting() public inState(State.Started) Owner {
        state = State.Voting;
    }


    function castVote(uint _choice, uint _pollingStationID) public inState(State.Voting) returns (bool voted) {

        bool found = false;

        if (voterRegistry[msg.sender].isEnrolled && !voterRegistry[msg.sender].hasVoted) {

            voterRegistry[msg.sender].choice = _choice;
            voterRegistry[msg.sender].votedPollingStationID = _pollingStationID;
            voterRegistry[msg.sender].hasVoted = true;

            pollingStations[_pollingStationID].votesCasted++;

            candidates[_choice].votes++;

            countResult++;
            found = true;
            voters[msg.sender] = found;

            pollingStations[_pollingStationID].scoresPerCandidate[_choice].votes += 1;

            emit VoteCasted(found, _choice, _pollingStationID);
        }
        return found;
    }

    function endVote() public inState(State.Voting) Owner { 
        state = State.Ended;
        finalResult = countResult;
    }

    function getResultsPerStationPerCandidate(uint _pStationID, uint _candidateID) public view returns (Candidate memory) {
        return pollingStations[_pStationID].scoresPerCandidate[_candidateID];
    }

}