<template>
  <div class="home">
    <MetamaskComponent />
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import store from "@/store";
import MetamaskComponent from "@/components/MetamaskComponent.vue"; // @ is an alias to /src
import { ContractInfo } from "@/store/contract";
import { ContractFactory } from "ethers";

export default defineComponent({
  name: "HomeView",
  components: {
    MetamaskComponent,
  },
  data() {
    return {
      details: {} as ContractInfo,
    };
  },
  created() {
    const details = new ContractInfo();
    this.details = details;
  },
  mounted() {
    this.fetchABI();
    this.fetchBytecode();
    // this.deploySmartContract();
    this.fetchContractAddress();
  },
  methods: {
    async fetchABI() {
      await store.dispatch("storeABI", this.details.getAbi());
    },
    async fetchBytecode() {
      await store.dispatch("storeBytecode", this.details.getBytecode());
    },
    async fetchContractAddress() {
      await store.dispatch(
        "storeContractAddress",
        this.details.getContractAddress()
      );
    },
    // async deploySmartContract() {
    //   // eslint-disable-next-line @typescript-eslint/no-explicit-any
    //   await new ContractInfo().deployContract().then(async () => {
    //     const address = await store.getters.ContractAddress;
    //     console.log(address);
    //   });
    // },
  },
});
</script>
