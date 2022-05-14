<template>
  <div class="container">
    <ElectorateComponent />
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import store from "@/store";
import ElectorateComponent from "./ElectorateComponent.vue";

export default defineComponent({
  name: "VotingComponent",
  components: {
    ElectorateComponent,
  },
  data() {
    return {
      currentAddress: "No Address provided, check your MetaMask Wallet",
    };
  },
  created() {
    this.currentAddress = store.getters.Accounts[0];
  },
});
</script>
