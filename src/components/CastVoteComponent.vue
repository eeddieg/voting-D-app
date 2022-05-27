<template>
  <div class="container">
    <h1>Cast Vote</h1>
  </div>
  <div class="container mt-3" v-show="isVisible">
    <button class="btn btn-outline-primary" @click="startVoting">
      Start Voting
    </button>
  </div>
  <div class="container" v-show="progressBarVisible">
    <div class="container">
      <h3>Voters are voting. Please wait...</h3>
    </div>
    <div class="container col-6">
      <div class="progress">
        <div
          id="progress-bar"
          class="progress-bar progress-bar-striped progress-bar-animated"
          role="progressbar"
          aria-valuenow="0"
          aria-valuemin="0"
          aria-valuemax="100"
          style="width: 0%"
        >
          {{ votersVoted.length }}%
        </div>
      </div>
    </div>
  </div>
  <div class="container mt-3 text-success" v-show="isVotingCompleted">
    <h3>Voting finished!</h3>
    <h4>Check results on other tabs</h4>
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
      isVisible: true,
      loading: false,
      progressBarVisible: false,
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
      this.totalRegisteredVoters = store.getters.VoterRegistry.length;
      this.votingStatus = status;
      if (status == State.Ended) {
        this.isVotingCompleted = true;
        // this.getResults();
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
        status = state;
        if (state == State.Created) {
          this.isVisible = true;
          this.isVotingCompleted = false;
          this.votingStatus = State.Created;
          store.dispatch("storeVotingCompleted", false);
          store.dispatch("storeVotingStatus", State.Created);
        } else if (state == State.Started) {
          this.isVisible = true;
          this.isVotingCompleted = false;
          this.votingStatus = State.Started;
          store.dispatch("storeVotingCompleted", false);
          store.dispatch("storeVotingStatus", State.Started);
        } else if (state == State.Voting) {
          this.isVisible = false;
          this.votingStatus = State.Voting;
          store.dispatch("storeVotingStatus", State.Voting);
        } else if (state == State.Ended) {
          this.isVisible = false;
          this.votingStatus = State.Ended;
          this.isVotingCompleted = true;
          store.dispatch("storeVotingCompleted", true);
          store.dispatch("storeVotingStatus", State.Ended);
        }
      });
      return status;
    },
    async startVoting() {
      const Contract = store.getters.ContractAsOwner;

      await Contract.startVoting()
        .then(() => {
          store.dispatch("storeVotingStatus", State.Voting);
        })
        .then(async () => {
          await this.castVote();
        });
    },
    async castVote() {
      const status = store.getters.VotingStatus;

      if (status == State.Voting) {
        this.isVisible = false;
        this.loading = true;
        this.progressBarVisible = true;

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
          this.updateProgressBar(this.votersVoted.length);
        }
        await this.endVoting();
        this.loading = false;
        this.progressBarVisible = false;
      } else {
        console.log("ERROR: Faulty voting status:", status);
        this.votingStatus = this.fetchVotingStatus();
      }
    },
    getRandomIntInclusive(min: number, max: number) {
      return Math.floor(Math.random() * (max - min + 1) + min);
    },
    updateProgressBar(count: number) {
      let bar = document.getElementById("progress-bar") as HTMLElement;

      const width = ((count / 100) * 100).toFixed(0);
      bar.ariaValueNow = width.toString();
      const val = "width: " + width + "%";
      bar.setAttribute("style", val);
    },
    async endVoting() {
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
  },
});
</script>

<style scoped>
.progress {
  height: 25px;
}
</style>
