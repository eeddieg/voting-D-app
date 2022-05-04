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
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { ethers } from "ethers";
import store from "@/store";
import ABI from "@/store/abi";
import ContractAddress from "@/store/contractAddress";
import { State } from "@/store/interfaces";

export default defineComponent({
  name: "ElectionsComponent",
  data() {
    return {
      accounts: [],
      contractAddress: "",
      currentAddress: "No Address provided, check your MetaMask Wallet",
      isVisible: true,
      votingStatus: State.Created,
      totalRegisteredVoters: 0,
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      voterRegister: [] as any[],
    };
  },
  created() {
    this.contractAddress = ContractAddress;
    this.currentAddress = store.getters.Accounts[0];
    this.init();
  },
  methods: {
    async init() {
      await this.fetchContractAsSinger();
    },
    async fetchContractAsSinger() {
      const provider = new ethers.providers.JsonRpcProvider();
      const signer = provider.getSigner(this.currentAddress);

      const Contract = await new ethers.Contract(ContractAddress, ABI, signer);
      store.dispatch("storeContractAsSigner", Contract);
    },
    async startVoting() {
      this.isVisible = false;
      await store.dispatch("storeVotingStatus", State.Voting);
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
