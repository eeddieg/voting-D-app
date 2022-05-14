<template>
  <div class="container">
    <h1 class="p-3 text-center">Voting Procedure</h1>
    <div class="container mt-3">
      <button
        class="btn btn-outline-dark"
        @click="startVoting"
        v-show="isVisible"
      >
        Begin Voting
      </button>
    </div>
    <div class="container mt-3" v-show="!isVisible">
      <h4>Voting procedure has started!</h4>
    </div>
    <div class="container mt-5" v-show="!isVisible">
      <CastVoteComponent />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { ethers } from "ethers";
import store from "@/store";
import { State } from "@/store/interfaces";
import CastVoteComponent from "@/components/CastVoteComponent.vue";

export default defineComponent({
  name: "ElectionsComponent",
  components: {
    CastVoteComponent,
  },
  data() {
    return {
      ABI: store.getters.ABI,
      accounts: [],
      contractAddress: store.getters.ContractAddress,
      currentAddress: "No Address provided, check your MetaMask Wallet",
      isVisible: false,
      votingStatus: State.Created,
      totalRegisteredVoters: 0,
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      voterRegister: [] as any[],
    };
  },
  created() {
    this.currentAddress = store.getters.Accounts[0];
    this.init();
  },
  methods: {
    async init() {
      await this.fetchContractAsOwner();
      await this.fetchVotingStatus();
    },
    async fetchContractAsOwner() {
      const provider = new ethers.providers.JsonRpcProvider();
      const owner = provider.getSigner(this.currentAddress);

      const Contract = new ethers.Contract(
        this.contractAddress,
        this.ABI,
        owner
      );
      await store.dispatch("storeContractAsOwner", Contract);
    },
    async fetchVotingStatus() {
      const Contract = store.getters.ContractAsOwner;

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await Contract.state().then((res: any) => {
        if (res == State.Created) {
          this.isVisible = true;
        }
      });
    },
    async startVoting() {
      this.isVisible = false;
      const Contract = store.getters.ContractAsOwner;

      await Contract.startVote().then();

      store.dispatch("storeVotingStatus", State.Voting);
    },
  },
});
</script>
