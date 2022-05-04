<template>
  <div class="container">
    <h1 class="p-3 text-center">Elections</h1>
    <div class="container mt-3">
      <article v-show="ElectorateStatus">
        <strong>
          Electorate is initiallized and counts
          {{ totalRegisteredVoters }} voters
        </strong>
      </article>
      <button
        class="btn btn-outline-dark"
        @click="initElectorate"
        v-show="!ElectorateStatus"
      >
        Intialize Electorate
      </button>
    </div>
  </div>
  <div class="container mt-5">
    <ElectionsComponent v-show="ElectorateStatus" />
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { ethers } from "ethers";
import store from "@/store";
import ABI from "@/store/abi";
import ContractAddress from "@/store/contractAddress";
import ElectionsComponent from "./ElectionsComponent.vue";

export default defineComponent({
  name: "ElectorateComponent",
  components: {
    ElectionsComponent,
  },
  data() {
    return {
      accounts: [],
      contractAddress: "",
      currentAddress: "No Address provided, check your MetaMask Wallet",
      ElectorateStatus: store.getters.ElectorateStatus,
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
      await this.checkElectorateStatus();
    },
    async fetchContractAsSinger() {
      const provider = new ethers.providers.JsonRpcProvider();
      const signer = provider.getSigner(this.currentAddress);

      const Contract = await new ethers.Contract(ContractAddress, ABI, signer);
      store.dispatch("storeContractAsSigner", Contract);
    },
    async initElectorate() {
      const contract = await store.getters.ContractAsSigner;
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
        this.ElectorateStatus = true;
      }
    },
    async checkElectorateStatus() {
      const contract = await store.getters.ContractAsSigner;

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await contract.totalRegisteredVoters().then((result: any) => {
        this.totalRegisteredVoters = parseInt(result.toString());
        store.dispatch("storeRegisteredVoters", this.totalRegisteredVoters);
      });

      if (this.totalRegisteredVoters > 0) {
        await store.dispatch("storeElectorateStatus", true);
        this.ElectorateStatus = true;
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

<style lang="scss" scoped>
.helloworld {
  margin: auto;
  width: 50%;
}
</style>
