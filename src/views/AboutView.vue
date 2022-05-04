<template>
  <Metamask />
  <div class="about">
    <h1>This is an about page</h1>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import Metamask from "@/components/MetamaskComponent.vue";
import store from "@/store";

export default defineComponent({
  name: "AboutView",
  components: {
    Metamask,
  },
  setup() {
    const isLogged = store.getters.isLogged;

    return {
      isLogged,
    };
  },
});
</script>
