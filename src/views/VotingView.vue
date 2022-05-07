<template>
  <MetamaskComponent />

  <div class="container mt-5">
    <VotingComponent />
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import MetamaskComponent from "@/components/MetamaskComponent.vue";
import VotingComponent from "@/components/VotingComponent.vue";

export default defineComponent({
  name: "ContractView",
  components: {
    VotingComponent,
    MetamaskComponent,
  },
});
</script>
