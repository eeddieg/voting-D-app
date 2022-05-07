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
import { ContractInfo } from "@/store/contract";
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
      contractAddress: new ContractInfo().getContractAddress(),
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
      await this.fetchContractAsSinger();
      await this.fetchVotingStatus();
    },
    async fetchContractAsSinger() {
      const provider = new ethers.providers.JsonRpcProvider();
      const signer = provider.getSigner(this.currentAddress);

      const Contract = await new ethers.Contract(
        this.contractAddress,
        this.ABI,
        signer
      );
      store.dispatch("storeContractAsSigner", Contract);
    },
    async fetchVotingStatus() {
      const contract = store.getters.ContractAsSigner;

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.state().then((res: any) => {
        if (res == State.Created) {
          this.isVisible = true;
        }
      });
    },
    async startVoting() {
      this.isVisible = false;
      const contract = store.getters.ContractAsSigner;

      await contract.startVote().then();

      store.dispatch("storeVotingStatus", State.Voting);
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
