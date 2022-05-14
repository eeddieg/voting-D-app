<template>
  <div class="container">
    <h1>Cast Vote</h1>
  </div>
  <div class="container mt-3" v-show="isVisible">
    <button class="btn btn-outline-primary" @click="castVote">
      Start Voting
    </button>
  </div>
  <div class="container" v-show="loading">
    <h3>Voters are voting. Please wait...</h3>
  </div>
  <div class="progress">
    <div
      class="progress-bar progress-bar-striped progress-bar-animated"
      role="progressbar"
      aria-valuenow="75"
      aria-valuemin="0"
      aria-valuemax="100"
      style="width: 95%"
    ></div>
  </div>
  <div class="spinner-border" role="status" v-show="loading">
    <span class="visually-hidden">Voting...</span>
  </div>
  <div class="container mt-3 text-success" v-show="isVotingCompleted">
    <h3>Voting finished!</h3>
    <h3>Check results</h3>
    <button
      class="btn btn-outline-primary"
      @click="getResults"
      v-show="!showResults"
    >
      Show Results
    </button>
    <button
      class="btn btn-outline-primary"
      @click="hideResults"
      v-show="showResults"
    >
      Hide Results
    </button>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { ethers } from "ethers";
import store from "@/store";
import { State } from "@/store/interfaces";

export default defineComponent({
  name: "CastVoteComponent",
  data() {
    return {
      ABI: store.getters.ABI,
      accounts: [],
      contractAddress: store.getters.ContractAddress,
      currentAddress: "No Address provided, check your MetaMask Wallet",
      isVotingCompleted: store.getters.VotingCompleted,
      isVisible: store.getters.VotingStatus == State.Voting ? true : false,
      loading: false,
      results: 0,
      showResults: false,
      totalRegisteredVoters: 0,
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      voterRegister: [] as any[],
      votersVoted: [] as boolean[],
      votingStatus: store.getters.VotingStatus,
    };
  },
  created() {
    this.accounts = store.getters.Accounts;
    this.currentAddress = store.getters.Accounts[0];
    this.init();
  },
  methods: {
    async init() {
      const status = await this.fetchVotingStatus();
      if (status == State.Ended) {
        this.votingStatus = State.Ended;
        this.isVotingCompleted = true;
        this.getResults();
      }
    },
    async fetchVotingStatus() {
      const provider = new ethers.providers.JsonRpcProvider();

      const contract = await new ethers.Contract(
        this.contractAddress,
        this.ABI,
        provider
      );

      let status;
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.state().then((state: any) => {
        store.dispatch("storeVotingStatus", state);
        if (state == State.Created) {
          status = state;
          this.isVisible = true;
        } else if (state == State.Voting) {
          status = state;
          this.isVisible = false;
          this.isVotingCompleted = false;
          store.dispatch("storeVotingCompleted", false);
        } else if (state == State.Ended) {
          status = state;
          this.isVotingCompleted = true;
          store.dispatch("storeVotingCompleted", true);
        }
      });
      return status;
    },
    async castVote() {
      const status = store.getters.VotingStatus;

      if (status == State.Voting) {
        this.isVisible = false;
        this.loading = true;

        const accounts = this.accounts;
        const provider = new ethers.providers.JsonRpcProvider();

        for (let account of accounts) {
          const signer = provider.getSigner(account);

          const contractInstance = await new ethers.Contract(
            this.contractAddress,
            this.ABI,
            signer
          );

          let candidateChoice = this.getRandomIntInclusive(1, 5);
          let pollingStationID = this.getRandomIntInclusive(1, 10);

          const tx = await contractInstance.castVote(
            candidateChoice,
            pollingStationID
          );
          const receipt = await tx.wait();

          const events = receipt?.events;
          const voted = events[0].args[0];
          this.votersVoted.push(voted);
        }

        await this.endVoting(accounts.length);
        this.loading = false;
      } else {
        console.log("ERROR: Faulty voting status:", status);
        this.votingStatus = this.fetchVotingStatus();
      }
    },
    getRandomIntInclusive(min: number, max: number) {
      return Math.floor(Math.random() * (max - min + 1) + min);
    },
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    async endVoting(size: number) {
      const voted = this.checkAllVoted();

      if (voted) {
        const contract = await store.getters.ContractAsOwner;

        await contract.endVote().then(async () => {
          await store.dispatch("storeVotingStatus", State.Ended);
          this.votingStatus = State.Ended;
          this.isVotingCompleted = true;
        });
      }
    },
    checkAllVoted() {
      let voted = true;
      for (let vote of this.votersVoted) {
        if (vote == false) {
          voted = false;
        }
      }
      return voted;
    },
    async getResults() {
      const provider = new ethers.providers.JsonRpcProvider();

      const contract = await new ethers.Contract(
        this.contractAddress,
        this.ABI,
        provider
      );

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.finalResult().then((results: any) => {
        const sum = parseInt(results.toString());
        store.dispatch("storeResults", sum);
        this.results = sum;
      });

      let pollingStations = 0;
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.pollingStationCount().then((res: any) => {
        pollingStations = parseInt(res.toString());
      });

      let candidates = 0;
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.candidatesCount().then((res: any) => {
        candidates = parseInt(res.toString());
      });

      let outcome = new Array(pollingStations);

      for (var i = 0; i < pollingStations; i++) {
        let counter = 0;
        let votesPerCandidate: number[] = new Array(candidates);

        for (var j = 0; j < candidates; j++) {
          await contract
            .getResultsPerStationPerCandidate(i, j)
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            .then((result: any) => {
              const votesReceived = parseInt(result.votes.toString());
              if (votesReceived > 0) {
                counter += votesReceived;
              }
              votesPerCandidate[j] = votesReceived;
            });
        }
        outcome[i] = {
          stationID: i,
          results: votesPerCandidate,
          totalVotes: counter,
        };
      }

      store.dispatch("storeVotingCompleted", true);
      store.dispatch("storeResultsPerStation", outcome);
      this.showResults = true;
    },
    hideResults() {
      this.showResults = false;
    },
  },
});
</script>
