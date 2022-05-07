<template>
  <MetamaskComponent />

  <VotersComponent />
</template>

<script lang="ts">
import { defineComponent } from "vue";
import MetamaskComponent from "@/components/MetamaskComponent.vue";
import VotersComponent from "@/components/VotersComponent.vue";

export default defineComponent({
  name: "ContractView",
  components: {
    VotersComponent,
    MetamaskComponent,
  },
});
</script>
