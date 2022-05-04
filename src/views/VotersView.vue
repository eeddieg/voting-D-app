<template>
  <Metamask />

  <VotersComponent />
</template>

<script lang="ts">
import { defineComponent } from "vue";
import Metamask from "@/components/MetamaskComponent.vue";
import VotersComponent from "@/components/VotersComponent.vue";

export default defineComponent({
  name: "ContractView",
  components: {
    VotersComponent,
    Metamask,
  },
});
</script>
