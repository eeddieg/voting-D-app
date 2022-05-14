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
      <ResultsTableComponent />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { ethers } from "ethers";
import store from "@/store";
import { PollingStation, State } from "@/store/interfaces";
import ResultsTableComponent from "./ResultsTableComponent.vue";
import { stdin } from "process";

export default defineComponent({
  name: "PollingStationComponent",
  components: { ResultsTableComponent },
  data() {
    return {
      ABI: store.getters.ABI,
      showPollingStation: false,
      contractAddress: store.getters.ContractAddress,
      currentAddress: "No Address provided, check your MetaMask Wallet",
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      pollingStationList: [] as any[],
      totalRegisteredVoters: 0,
      votingStatus: undefined,
      votingCompleted: false,
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
  },
});
</script>
