<template>
  <div class="container">
    <h1>Cast Vote</h1>
  </div>
  <div class="container mt-3" v-show="isVisible">
    <button class="btn btn-outline-primary" @click="castVote">
      Start Voting
    </button>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { ethers } from "ethers";
import store from "@/store";
import ContractAddress from "@/store/contractAddress";
import { State } from "@/store/interfaces";

export default defineComponent({
  name: "CastVoteComponent",
  data() {
    return {
      ABI: store.getters.ABI,
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
      await this.fetchVotingStatus();
    },
    async fetchContractAsSinger() {
      const provider = new ethers.providers.JsonRpcProvider();
      const signer = provider.getSigner(this.currentAddress);

      const Contract = await new ethers.Contract(
        ContractAddress,
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
    async castVote() {
      this.isVisible = false;

      const contract = store.getters.Contract;
      const accounts = store.getters.Accounts;

      for (let account of accounts) {
        let candidateChoice = this.getRandomIntInclusive(1, 5);
        let pollingStation = this.getRandomIntInclusive(1, 10);
        await contract
          .castVote(candidateChoice, pollingStation)
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          .then((res: any) => {
            // console.log(res);
          });
      }
    },
    getRandomIntInclusive(min: number, max: number) {
      return Math.floor(Math.random() * (max - min + 1) + min);
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
