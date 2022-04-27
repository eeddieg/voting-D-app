<template>
  <div class="home">
    <MetamaskComponent></MetamaskComponent>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import MetamaskComponent from "@/components/MetamaskComponent.vue"; // @ is an alias to /src

export default defineComponent({
  name: "HomeView",
  components: {
    MetamaskComponent,
  },
});
</script>
