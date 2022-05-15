<template>
  <div class="container">
    <h1 class="p-3 text-center">Polling Stations</h1>
    <div class="container mt-3">
      <button
        class="btn btn-outline-dark"
        @click="displayPollingStation"
        v-show="!showPollingStation"
      >
        Show Polling Stations
      </button>
      <button
        class="btn btn-outline-dark"
        @click="displayPollingStation"
        v-show="showPollingStation"
      >
        Hide Polling Stations
      </button>
    </div>
    <div
      id="table"
      class="row justify-content-center mt-5"
      v-show="showPollingStation"
    >
      <div class="col-auto">
        <table class="table table-responsive table-striped w-auto">
          <thead>
            <tr>
              <th scope="col">Polling Station ID</th>
              <th scope="col">Name</th>
              <th scope="col">Voters Registered</th>
              <th scope="col">Votes Casted</th>
            </tr>
          </thead>
          <tbody>
            <tr
              scope="row"
              v-for="station in pollingStationList"
              :key="station.id"
            >
              <td>{{ station.id }}</td>
              <td>{{ station.name }}</td>
              <td>{{ station.votersRegistered }}</td>
              <td>{{ station.votesCasted }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    <div class="container mt-5" v-show="showPollingStation && votingCompleted">
      <button
        class="btn btn-outline-success"
        @click="toggleMoreDetails"
        v-show="enableMoreDetails"
      >
        More details
      </button>
      <button
        class="btn btn-outline-success"
        @click="toggleMoreDetails"
        v-show="!enableMoreDetails"
      >
        Hide details
      </button>
    </div>
    <div class="container" v-show="loading">
      <h3>Fetching results. Please wait...</h3>
      <div class="spinner-border mt-4" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
    </div>
    <div class="container mt-5" v-show="showMoreDetailsDiv">
      <ResultsTableComponent
        :headers="headers"
        :data="outcome"
        :counter="candidatesCounter"
        :totalVotes="totalVotes"
      />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { ethers } from "ethers";
import store from "@/store";
import { PollingStation, State } from "@/store/interfaces";
import ResultsTableComponent from "./ResultsTableComponent.vue";

export default defineComponent({
  name: "PollingStationComponent",
  components: { ResultsTableComponent },
  data() {
    return {
      ABI: store.getters.ABI,
      candidatesCounter: 0,
      contractAddress: store.getters.ContractAddress,
      currentAddress: "No Address provided, check your MetaMask Wallet",
      enableMoreDetails: true,
      loading: false,
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      outcome: [] as any[],
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      pollingStationList: [] as any[],
      showMoreDetailsDiv: false,
      showPollingStation: false,
      totalRegisteredVoters: 0,
      totalVotes: 0,
      votingStatus: undefined,
      votingCompleted: false,
      headers: [
        {
          key: "polStationID",
          value: "Polling Station ID",
        },
        {
          key: "candidate_1",
          value: "Candidate 1",
        },
        {
          key: "candidate_2",
          value: "Candidate 2",
        },
        {
          key: "candidate_3",
          value: "Candidate 3",
        },
        {
          key: "candidate_4",
          value: "Candidate 4",
        },
        {
          key: "candidate_5",
          value: "Candidate 5",
        },
        {
          key: "totalVotes",
          value: "Total Votes",
        },
      ],
    };
  },
  created() {
    this.init();
  },
  mounted() {
    this.currentAddress = store.getters.Accounts[0];
    this.totalRegisteredVoters = store.getters.RegisteredVoters;
  },
  methods: {
    async init() {
      await this.fetchContract();
      await this.fetchPollingStations();
      await this.checkStatus();
      await this.fetchResults();
    },
    async fetchContract() {
      const provider = new ethers.providers.JsonRpcProvider();
      const contract = await new ethers.Contract(
        this.contractAddress,
        this.ABI,
        provider
      );
      store.dispatch("storeContract", contract);
    },
    async fetchPollingStations() {
      const contract = await store.getters.Contract;
      let pollingStations = 0;
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.pollingStationCount().then((res: any) => {
        pollingStations = parseInt(res.toString());
      });
      for (var i = 1; i <= pollingStations; i++) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        await contract.pollingStations(i).then((result: any) => {
          let station: PollingStation = {
            id: parseInt(result.id.toString()),
            name: result.name,
            votersRegistered: parseInt(result.votersRegistered.toString()),
            votesCasted: parseInt(result.votesCasted.toString()),
            scoresPerCandidate: [],
          };
          this.pollingStationList.push(station);
        });
      }
      store.dispatch("storePollingStations", this.pollingStationList);
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.totalRegisteredVoters().then((result: any) => {
        store.dispatch("storeRegisteredVoters", parseInt(result.toString()));
      });
    },
    async checkStatus() {
      const contract = await store.getters.Contract;

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.state().then((state: any) => {
        store.dispatch("storeVotingStatus", state);
        this.votingStatus = state;
        if (state == State.Ended) {
          this.votingCompleted = true;
          store.dispatch("storeVotingStatus", true);
        }
      });
    },
    async displayPollingStation() {
      this.votingStatus = await store.getters.VotingStatus;
      if (this.votingStatus == State.Ended) {
        this.votingCompleted = true;
      }

      if (!this.showPollingStation) {
        this.pollingStationList = await store.getters.PollingStations;
        this.totalRegisteredVoters = await store.getters.RegisteredVoters;
      }
      this.showPollingStation = !this.showPollingStation;
    },
    async fetchResults() {
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
        this.candidatesCounter = candidates;
      });

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.finalResult().then((res: any) => {
        this.totalVotes = parseInt(res.toString());
        store.dispatch("storeResults", this.totalVotes);
      });

      let outcome = new Array(pollingStations);

      for (var i = 0; i < pollingStations; i++) {
        let counter = 0;
        let votesPerCandidate: number[] = new Array(candidates);

        for (var j = 0; j < candidates; j++) {
          await contract
            .getResultsPerStationPerCandidate(i + 1, j + 1) // Smart contract values are 1 to 5 and 1 to 10, not 0
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
          stationID: i + 1,
          results: votesPerCandidate,
          totalVotes: counter,
        };
      }
      await store.dispatch("storeResultsPerStation", outcome);
      this.outcome = outcome;
    },

    async toggleMoreDetails() {
      this.enableMoreDetails = !this.enableMoreDetails;

      if (!this.enableMoreDetails) {
        this.loading = true;
        let outcome = await store.getters.ResultsPerStation;

        // // console.log(JSON.stringify(outcome.Target) == undefined);
        // // console.log(Object.keys(outcome).length === 0);
        // if (Object.keys(outcome).length === 0) {
        //   // eslint-disable-next-line @typescript-eslint/no-explicit-any
        //   await this.fetchResults().then(async (result: any) => {
        //     await store.dispatch("storeResultsPerStation", result);
        //     outcome = result;
        //   });
        // }

        this.outcome = outcome;
        this.loading = false;
      }
      this.showMoreDetailsDiv = !this.showMoreDetailsDiv;
    },
  },
});
</script>
