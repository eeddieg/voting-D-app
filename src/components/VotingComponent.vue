<template>
  <div class="container">
    <ElectorateComponent />
  </div>
  <div class="container mt-5">
    <h4>Owner account: {{ currentAddress }}</h4>
    <h4>Contract address: {{ contractAddress }}</h4>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import store from "@/store";
import ContractAddress from "@/store/contractAddress";
import ElectorateComponent from "./ElectorateComponent.vue";

export default defineComponent({
  name: "VotingComponent",
  components: {
    ElectorateComponent,
  },
  data() {
    return {
      contractAddress: "",
      currentAddress: "No Address provided, check your MetaMask Wallet",
    };
  },
  created() {
    this.contractAddress = ContractAddress;
    this.currentAddress = store.getters.Accounts[0];
  },
});
</script>

<style lang="scss" scoped>
.helloworld {
  margin: auto;
  width: 50%;
}
</style>
