<template>
  <MetamaskComponent />

  <BallotComponent />
</template>

<script lang="ts">
import { defineComponent } from "vue";
import MetamaskComponent from "@/components/MetamaskComponent.vue";
import BallotComponent from "@/components/BallotComponent.vue";

export default defineComponent({
  name: "BallotView",
  components: {
    BallotComponent,
    MetamaskComponent,
  },
});
</script>
