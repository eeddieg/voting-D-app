<template>
  <div class="container">
    <h1 class="p-3 text-center">Ballot</h1>
    <div class="container mt-3">
      <button
        class="btn btn-outline-dark"
        @click="displayBallot"
        v-show="!showBallot"
      >
        Show Ballot
      </button>
      <button
        class="btn btn-outline-dark"
        @click="displayBallot"
        v-show="showBallot"
      >
        Hide Ballot
      </button>
    </div>
    <div id="table" class="row justify-content-center mt-5" v-show="showBallot">
      <div class="col-auto">
        <table class="table table-responsive table-striped w-auto">
          <thead>
            <tr>
              <th scope="col">Candidate ID</th>
              <th scope="col">Candidate Name</th>
              <th scope="col">Votes</th>
            </tr>
          </thead>
          <tbody>
            <tr scope="row" v-for="candidate in ballot" :key="candidate.id">
              <td>{{ candidate.id }}</td>
              <td>{{ candidate.name }}</td>
              <td>{{ candidate.votes }}</td>
            </tr>
          </tbody>
        </table>
        <article class="mt-4">
          <div>
            <h3>Number of Canditates: {{ numOfCandidates }}</h3>
          </div>
        </article>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { ethers } from "ethers";
import store from "@/store";
import { Candidate } from "@/store/interfaces";

export default defineComponent({
  name: "BallotComponent",
  data() {
    return {
      ABI: store.getters.ABI,
      contractAddress: store.getters.ContractAddress,
      currentAddress: "No Address provided, check your MetaMask Wallet",
      numOfCandidates: 0,
      showBallot: false,
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      ballot: [] as any[],
    };
  },
  created() {
    this.init();
  },
  mounted() {
    this.currentAddress = store.getters.Accounts[0];
  },
  methods: {
    async init() {
      await this.fetchContract();
      await this.fetchBallot();
    },
    async fetchContract() {
      const provider = new ethers.providers.JsonRpcProvider();

      const electionContract = await new ethers.Contract(
        this.contractAddress,
        this.ABI,
        provider
      );
      store.dispatch("storeContract", electionContract);
    },
    async fetchBallot() {
      const contract = await store.getters.Contract;

      let numOfCandidates = 0;
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.candidatesCount().then((res: any) => {
        numOfCandidates = parseInt(res.toString());
        this.numOfCandidates = numOfCandidates;
      });

      for (var i = 1; i <= numOfCandidates; i++) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        await contract.candidates(i).then((result: any) => {
          let candidate: Candidate = {
            id: parseInt(result.id.toString()),
            name: result.name,
            votes: parseInt(result.votes.toString()),
          };
          this.ballot.push(candidate);
        });
      }
      store.dispatch("storeBallot", this.ballot);
    },
    async displayBallot() {
      if (!this.showBallot) {
        this.showBallot = !this.showBallot;
        this.ballot = await store.getters.Ballot;
      } else {
        this.showBallot = !this.showBallot;
      }
    },
  },
});
</script>

<style lang="scss" scoped>
.helloworld {
  margin: auto;
  width: 50%;
}
</style>
