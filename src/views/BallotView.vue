<template>
  <Metamask />

  <BallotComponent />
</template>

<script lang="ts">
import { defineComponent } from "vue";
import Metamask from "@/components/MetamaskComponent.vue";
import BallotComponent from "@/components/BallotComponent.vue";

export default defineComponent({
  name: "ContractView",
  components: {
    BallotComponent,
    Metamask,
  },
});
</script>
