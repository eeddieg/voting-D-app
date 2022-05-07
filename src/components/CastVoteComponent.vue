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
import { State } from "@/store/interfaces";

export default defineComponent({
  name: "CastVoteComponent",
  data() {
    return {
      ABI: store.getters.ABI,
      accounts: [],
      contractAddress: store.getters.ContractAddress,
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
      await this.fetchVotingStatus();
    },
    async fetchVotingStatus() {
      const provider = new ethers.providers.JsonRpcProvider();

      const contract = await new ethers.Contract(
        this.contractAddress,
        this.ABI,
        provider
      );

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.state().then((res: any) => {
        if (res == State.Created) {
          this.isVisible = true;
        }
      });
    },
    async castVote() {
      const status = store.getters.VotingStatus;

      if (status == State.Voting) {
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
          let pollingStationID = this.getRandomIntInclusive(1, 10);

          await contractInstance
            .castVote(candidateChoice, pollingStationID)
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            .then((res: any) => {
              console.log(res);
            });
        }
      } else {
        console.log("ERROR: Faulty voting status:", status);
        this.fetchVotingStatus();
      }

      // await contractInstance
      //   .castVote(candidateChoice, pollingStationID)
      //   // eslint-disable-next-line @typescript-eslint/no-explicit-any
      //   .then((res: any) => {
      //     console.log(res);
      //   });
      // await contractInstance.castVote(candidateChoice, pollingStationID).then();

      // for (let account of accounts) {
      //   const signer = provider.getSigner(account);

      //   const contractInstance = await new ethers.Contract(
      //     this.contractAddress,
      //     this.ABI,
      //     signer
      //   );

      //   let candidateChoice = this.getRandomIntInclusive(1, 5);
      //   let pollingStationID = this.getRandomIntInclusive(1, 10);

      //   await contractInstance.castVote(candidateChoice, pollingStationID);

      // await contractInstance
      //   .castVote(candidateChoice, pollingStation)
      //   // eslint-disable-next-line @typescript-eslint/no-explicit-any
      //   .then((res: any) => {
      //     console.log(res);
      //   });
      // }

      // this.endVoting(accounts.length);
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
        const contract = store.getters.ContractAsOwner;
        console.log(contract);
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        // await contract.endVote().then(
        //   // eslint-disable-next-line @typescript-eslint/no-explicit-any
        //   await contract.state().then((res: any) => {
        //     console.log(res);
        //   })
        // );
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
