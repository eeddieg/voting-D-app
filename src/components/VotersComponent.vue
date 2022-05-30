<template>
  <div class="container">
    <h1 class="p-3 text-center">Voter Registry</h1>
    <div class="container mt-3" v-show="!isRegistrationCompleted">
      <h3>
        There are no voters registered yet. Please initialize electorate from
        Vote tab.
      </h3>
    </div>
    <div class="container mt-3" v-show="isRegistrationCompleted">
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
      <div class="container">
        <VotersTableComponent
          :headers="headers"
          :data="registry"
          v-show="showRegistry"
        />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { ethers } from "ethers";
import store from "@/store";
import { Voter } from "@/store/interfaces";
import VotersTableComponent from "./VotersTableComponent.vue";

export default defineComponent({
  name: "VotingComponent",
  components: { VotersTableComponent },
  data() {
    return {
      ABI: store.getters.ABI,
      accounts: [],
      contractAddress: store.getters.ContractAddress,
      currentAddress: "No Address provided, check your MetaMask Wallet",
      isRegistrationCompleted: store.getters.ElectorateStatus,
      showRegistry: false,
      totalRegisteredVoters: 0,
      registry: store.getters.VoterRegistry,
      headers: [
        {
          key: "index",
          value: "#",
        },
        {
          key: "id",
          value: "Voter Registered",
        },
        {
          key: "voted",
          value: "Voter Voted",
        },
        {
          key: "registrationID",
          value: "Registration Polling Station ID",
        },
        {
          key: "pollingID",
          value: "Vote Polling Station ID",
        },
      ],
    };
  },
  created() {
    this.init();
  },
  mounted() {
    this.currentAddress = store.getters.Accounts[0];
    this.registry = store.getters.VoterRegistry;
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
        this.contractAddress,
        this.ABI,
        signer
      );
      store.dispatch("storeContract", electionContract);
    },
    async fetchVoterRegistry() {
      this.registry = store.getters.VoterRegistry;

      if (this.registry.length == 0) {
        const contract = await store.getters.Contract;

        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        await contract
          .totalRegisteredVoters()
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          .then((totalRegVoters: any) => {
            this.totalRegisteredVoters = parseInt(totalRegVoters.toString());
            store.dispatch("storeRegisteredVoters", this.totalRegisteredVoters);
            if (this.totalRegisteredVoters > 0) {
              store.dispatch("storeElectorateStatus", true);
              this.isRegistrationCompleted = store.getters.ElectorateStatus;
            }
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
              choice: parseInt(result.choice.toString()),
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
