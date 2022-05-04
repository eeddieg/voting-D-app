<template>
  <Metamask />

  <VotingComponent />
</template>

<script lang="ts">
import { defineComponent } from "vue";
import Metamask from "@/components/MetamaskComponent.vue";
import VotingComponent from "@/components/VotingComponent.vue";

export default defineComponent({
  name: "ContractView",
  components: {
    VotingComponent,
    Metamask,
  },
});
</script>
