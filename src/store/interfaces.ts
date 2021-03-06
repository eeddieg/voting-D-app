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
  scoresPerCandidate: Candidate[];
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
  Started,
  Voting,
  Ended,
}

export { Candidate, PollingStation, State, Voter };
