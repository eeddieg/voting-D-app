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
    // this.deployContract(privateKey, provider);
    this.fetchABI();
    this.fetchBytecode();
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
  },
});
</script>
