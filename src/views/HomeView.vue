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
    this.fetchABI();
    this.fetchBytecode();
    // this.deployContract(privateKey, provider);
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
  },
});
</script>
