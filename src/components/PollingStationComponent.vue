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
        <article>
          <div>
            <h3>Number of Polling stations: {{ pollingStationList.length }}</h3>
            <h3>Number of Voters Registered: {{ totalRegisteredVoters }}</h3>
          </div>
        </article>
      </div>
      <div class="container mt-5">
        <h4>Owner account: {{ currentAddress }}</h4>
        <h4>Contract address: {{ contractAddress }}</h4>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { ethers } from "ethers";
import store from "@/store";
import ABI from "@/store/abi";
import ContractAddress from "@/store/contractAddress";
import { PollingStation } from "@/store/interfaces";

export default defineComponent({
  name: "PollingStationComponent",
  data() {
    return {
      showPollingStation: false,
      contractAddress: "",
      currentAddress: "No Address provided, check your MetaMask Wallet",
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      pollingStationList: [] as any[],
      totalRegisteredVoters: 0,
    };
  },
  created() {
    this.init();
  },
  mounted() {
    this.contractAddress = ContractAddress;
    this.currentAddress = store.getters.Accounts[0];
    this.totalRegisteredVoters = store.getters.RegisteredVoters;
  },
  methods: {
    async init() {
      await this.fetchContract();
      await this.fetchPollingStations();
    },
    async fetchContract() {
      const provider = new ethers.providers.JsonRpcProvider();

      const contract = await new ethers.Contract(
        ContractAddress,
        ABI,
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
          };
          this.pollingStationList.push(station);
        });
      }
      store.dispatch("storePollingStations", this.pollingStationList);

      await contract.totalRegisteredVoters().then((result: any) => {
        store.dispatch("storeRegisteredVoters", parseInt(result.toString()));
      });
    },
    async displayPollingStation() {
      if (!this.showPollingStation) {
        this.pollingStationList = await store.getters.PollingStations;
        this.totalRegisteredVoters = await store.getters.RegisteredVoters;
      }
      this.showPollingStation = !this.showPollingStation;
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
