<template>
  <div class="container">
    <h1 class="p-3 text-center">Voter Registry</h1>
    <div class="container mt-3">
      <button
        class="btn btn-outline-dark"
        @click="displayRegistry"
        v-show="!showRegistry"
      >
        Show Registry
      </button>
      <button
        class="btn btn-outline-dark"
        @click="displayRegistry"
        v-show="showRegistry"
      >
        Hide Registry
      </button>
    </div>
    <div
      id="table"
      class="row justify-content-center mt-5"
      v-show="showRegistry"
    >
      <div class="col-auto">
        <table class="table table-responsive table-striped w-auto">
          <thead>
            <tr>
              <th scope="col">Voter Registered</th>
              <th scope="col">Voter Voted</th>
              <th scope="col">Vote</th>
              <th scope="col">Registration P. Station ID</th>
              <th scope="col">Vote P. Station ID</th>
            </tr>
          </thead>
          <tbody>
            <tr scope="row" v-for="voter in registry" :key="voter.id">
              <td>{{ voter.isEnrolled ? "YES" : "NO" }}</td>
              <td>{{ voter.hasVoted ? "YES" : "NO" }}</td>
              <td>{{ voter.indexProposal }}</td>
              <td>{{ voter.enrolledPollingStationID }}</td>
              <td>{{ voter.votedPollingStationID }}</td>
            </tr>
          </tbody>
        </table>
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
import { Voter } from "@/store/interfaces";

export default defineComponent({
  name: "VotingComponent",
  data() {
    return {
      accounts: [],
      contractAddress: "",
      currentAddress: "No Address provided, check your MetaMask Wallet",
      showRegistry: false,
      totalRegisteredVoters: 0,
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      registry: [] as any[],
    };
  },
  created() {
    this.init();
  },
  mounted() {
    this.contractAddress = ContractAddress;
    this.currentAddress = store.getters.Accounts[0];
  },
  methods: {
    async init() {
      await this.fetchContract();
      await this.fetchVoterRegistry();
    },
    async fetchContract() {
      const provider = new ethers.providers.JsonRpcProvider();

      const signer = provider.getSigner();

      const electionContract = await new ethers.Contract(
        ContractAddress,
        ABI,
        signer
      );
      store.dispatch("storeContractAsSigner", electionContract);
    },
    async fetchVoterRegistry() {
      const contract = await store.getters.ContractAsSigner;

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract
        .totalRegisteredVoters()
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        .then((totalRegVoters: any) => {
          this.totalRegisteredVoters = parseInt(totalRegVoters.toString());
          store.dispatch("storeRegisteredVoters", this.totalRegisteredVoters);
        })
        .then(() => {
          this.accounts = store.getters.Accounts;
        });

      for (let i = 0; i < this.totalRegisteredVoters; i++) {
        let voterAddress = this.accounts[i];
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        await contract.voterRegistry(voterAddress).then((result: any) => {
          let voter: Voter = {
            isEnrolled: result.isEnrolled,
            hasVoted: result.hasVoted,
            indexProposal: parseInt(result.indexProposal.toString()),
            enrolledPollingStationID: parseInt(
              result.enrolledPollingStationID.toString()
            ),
            votedPollingStationID: parseInt(
              result.votedPollingStationID.toString()
            ),
          };
          this.registry.push(voter);
        });
      }

      store.dispatch("storeVoterRegistry", this.registry);
    },
    async displayRegistry() {
      if (!this.showRegistry) {
        this.showRegistry = !this.showRegistry;
        this.registry = await store.getters.VoterRegistry;
      } else {
        this.showRegistry = !this.showRegistry;
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
