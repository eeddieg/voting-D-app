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
import { ContractInfo } from "@/store/contract";
import { State } from "@/store/interfaces";

export default defineComponent({
  name: "CastVoteComponent",
  data() {
    return {
      ABI: store.getters.ABI,
      accounts: [],
      contractAddress: new ContractInfo().getContractAddress(),
      currentAddress: "No Address provided, check your MetaMask Wallet",
      isVisible: true,
      votingStatus: State.Created,
      totalRegisteredVoters: 0,
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      voterRegister: [] as any[],
    };
  },
  created() {
    this.accounts = store.getters.Accounts;
    this.currentAddress = store.getters.Accounts[0];
    this.init();
  },
  methods: {
    async init() {
      await this.fetchContract();
      await this.fetchContractAsSinger();
      await this.fetchVotingStatus();
    },
    async fetchContract() {
      const provider = new ethers.providers.JsonRpcProvider();

      const Contract = await new ethers.Contract(
        this.contractAddress,
        this.ABI,
        provider
      );
      store.dispatch("storeContract", Contract);
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
    async castVote() {
      this.isVisible = false;

      const accounts = this.accounts;

      const provider = new ethers.providers.JsonRpcProvider();

      for (let account of accounts) {
        const signer = provider.getSigner(account);

        const contractInstance = await new ethers.Contract(
          this.contractAddress,
          this.ABI,
          signer
        );

        let candidateChoice = this.getRandomIntInclusive(1, 5);
        let pollingStation = this.getRandomIntInclusive(1, 10);

        await contractInstance
          .castVote(candidateChoice, pollingStation)
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          .then((res: any) => {
            console.log(res);
          });
      }

      this.endVoting(accounts.length);
    },
    getRandomIntInclusive(min: number, max: number) {
      return Math.floor(Math.random() * (max - min + 1) + min);
    },
    async checkVotersVoted(size: number) {
      let totalVotes = 0;

      const contract = await store.getters.Contract;

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.totalVotes().then((res: any) => {
        totalVotes = parseInt(res.toString());
      });

      if (totalVotes == size) {
        return true;
      } else {
        return false;
      }
    },
    async endVoting(size: number) {
      if (await this.checkVotersVoted(size)) {
        const contract = store.getters.ContractAsSigner;
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        await contract.endVote().then(
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          await contract.state().then((res: any) => {
            console.log(res);
          })
        );
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
