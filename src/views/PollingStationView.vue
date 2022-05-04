<template>
  <Metamask />

  <PollingStationComponent />
</template>

<script lang="ts">
import { defineComponent } from "vue";
import Metamask from "@/components/MetamaskComponent.vue";
import PollingStationComponent from "@/components/PollingStationComponent.vue";

export default defineComponent({
  name: "PollingStationView",
  components: {
    PollingStationComponent,
    Metamask,
  },
});
</script>
