<template>
  <div class="container">
    <h1>Cast Vote</h1>
  </div>
  <div class="container mt-3">
    <button class="btn btn-outline-primary" @click="castVote">
      Intialize Electorate
    </button>
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
  name: "CastVoteComponent",
  data() {
    return {
      accounts: [],
      contractAddress: "",
      currentAddress: "No Address provided, check your MetaMask Wallet",
      isVisible: false,
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
      await this.fetchVotingStatus();
    },
    async fetchContractAsSinger() {
      const provider = new ethers.providers.JsonRpcProvider();
      const signer = provider.getSigner(this.currentAddress);

      const Contract = await new ethers.Contract(ContractAddress, ABI, signer);
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
    async castVote() {
      this.isVisible = false;

      console.log(store.getters.Bytecode);

      //   const contract = store.getters.ContractAsSigner;

      //   await contract.startVote().then((res: any) => {
      //     // console.log(res);
      //   });
      //   store.dispatch("storeVotingStatus", State.Voting);
      //   console.log(store.getters.VotingStatus);
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
