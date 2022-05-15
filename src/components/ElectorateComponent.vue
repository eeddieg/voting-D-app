<template>
  <div class="container">
    <h1 class="p-3 text-center">Elections</h1>
    <div class="container mt-3">
      <article v-show="ElectorateStatus && !loading">
        <h4>
          Electorate is initiallized and counts
          {{ totalRegisteredVoters }} voters
        </h4>
      </article>
      <button
        class="btn btn-outline-dark"
        @click="initElectorate"
        v-show="!ElectorateStatus"
      >
        Intialize Electorate
      </button>
      <div class="container" v-show="loading">
        <h3>Registering voters. Please wait...</h3>
        <div class="spinner-border mt-4" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
      </div>
    </div>
  </div>
  <div class="container mt-5">
    <ElectionsComponent v-show="ElectorateStatus && !loading" />
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { ethers } from "ethers";
import store from "@/store";
import ElectionsComponent from "./ElectionsComponent.vue";

export default defineComponent({
  name: "ElectorateComponent",
  components: {
    ElectionsComponent,
  },
  data() {
    return {
      abi: store.getters.ABI,
      accounts: [],
      contractAddress: store.getters.ContractAddress,
      currentAddress: "No Address provided, check your MetaMask Wallet",
      ElectorateStatus: store.getters.ElectorateStatus,
      loading: false,
      totalRegisteredVoters: store.getters.RegisteredVoters,
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
      await this.checkElectorateStatus();
    },
    async fetchContractAsOwner() {
      const provider = new ethers.providers.JsonRpcProvider();
      const owner = provider.getSigner(this.currentAddress);

      const Contract = new ethers.Contract(
        this.contractAddress,
        this.abi,
        owner
      );

      await store.dispatch("storeContractAsOwner", Contract);
    },
    async checkElectorateStatus() {
      const contract = await store.getters.ContractAsOwner;

      let voters = 0;
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.totalRegisteredVoters().then((result: any) => {
        voters = parseInt(result.toString());
        store.dispatch("storeRegisteredVoters", voters);
      });

      if (voters > 0) {
        await store.dispatch("storeElectorateStatus", true);
        this.ElectorateStatus = true;
        this.totalRegisteredVoters = voters;
      }
    },
    async initElectorate() {
      this.ElectorateStatus = true;
      this.loading = true;

      const contract = await store.getters.ContractAsOwner;
      this.accounts = await store.getters.Accounts;
      const accounts = this.accounts;

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.totalRegisteredVoters().then((result: any) => {
        this.totalRegisteredVoters = parseInt(result.toString());
      });

      if (this.totalRegisteredVoters == 0) {
        for (let account of accounts) {
          const ID = this.getRandomIntInclusive();
          const voterAddress = account;

          await contract.addVoter(voterAddress, ID);
        }

        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        await contract.totalRegisteredVoters().then((result: any) => {
          store.dispatch("storeRegisteredVoters", parseInt(result.toString()));
        });
        await store.dispatch("storeElectorateStatus", true);
        this.totalRegisteredVoters = store.getters.RegisteredVoters;
        this.loading = false;
      }
    },
    getRandomIntInclusive() {
      const min = 1;
      const max = 10;
      return Math.floor(Math.random() * (max - min + 1) + min);
    },
  },
});
</script>

<style scoped>
.progress {
  height: 25px;
}
</style>
