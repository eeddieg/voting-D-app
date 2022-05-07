<template>
  <MetamaskComponent />

  <PollingStationComponent />
</template>

<script lang="ts">
import { defineComponent } from "vue";
import MetamaskComponent from "@/components/MetamaskComponent.vue";
import PollingStationComponent from "@/components/PollingStationComponent.vue";

export default defineComponent({
  name: "PollingStationView",
  components: {
    PollingStationComponent,
    MetamaskComponent,
  },
});
</script>
