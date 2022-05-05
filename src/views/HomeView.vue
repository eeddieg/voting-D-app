<template>
  <div class="home">
    <MetamaskComponent />
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import store from "@/store";
import MetamaskComponent from "@/components/MetamaskComponent.vue"; // @ is an alias to /src
import { ContractDetails } from "@/store/contract";
import { ethers } from "ethers";

export default defineComponent({
  name: "HomeView",
  components: {
    MetamaskComponent,
  },
  data() {
    return {
      details: {} as ContractDetails,
    };
  },
  created() {
    const details = new ContractDetails();
    this.details = details;
  },
  mounted() {
    this.fetchABI();
    this.fetchBytecode();
    // this.initSmartContract();
  },
  methods: {
    async fetchABI() {
      const ABI = this.details.getAbi();
      await store.dispatch("storeABI", ABI);
    },
    async fetchBytecode() {
      const Bytecode = this.details.getBytecode();
      await store.dispatch("storeBytecode", Bytecode);
    },
    async initSmartContract() {
      const abi = await store.getters.ABI;
      const bytecode = await store.getters.Bytecode;

      const provider = new ethers.providers.JsonRpcProvider();
      const privateKey =
        "0x38168ccec41fda8a0c9e076c276dc25072f6a26c7887a7d19216260f1fc41ca6";
      const wallet = new ethers.Wallet(privateKey, provider);

      let factory = new ethers.ContractFactory(abi, bytecode, wallet);

      const contract = await factory.deploy();

      await store.dispatch("storeContract", contract);
      await store.dispatch("storeContractAddress", contract.address);
    },
  },
});
</script>
