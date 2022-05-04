interface Candidate {
  id: number;
  name: string;
  votes: number;
}

interface PollingStation {
  id: number;
  name: string;
  votersRegistered: number;
  votesCasted: number;
}

interface Voter {
  isEnrolled: boolean;
  hasVoted: boolean;
  choice: number;
  enrolledPollingStationID: number;
  votedPollingStationID: number;
}

enum State {
  Created,
  Voting,
  Ended,
}

export { Candidate, PollingStation, State, Voter };
