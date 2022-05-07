<template>
  <MetamaskComponent />

  <ContractComponent />
</template>

<script lang="ts">
import { defineComponent } from "vue";
import MetamaskComponent from "@/components/MetamaskComponent.vue";
import ContractComponent from "@/components/ContractComponent.vue";

export default defineComponent({
  name: "ContractView",
  components: {
    ContractComponent,
    MetamaskComponent,
  },
});
</script>
