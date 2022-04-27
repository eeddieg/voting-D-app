<template>
  <NavBar :isLogged="isLogged" />
  <div class="about">
    <h1>This is an about page</h1>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import NavBar from "@/components/NavBar.vue";
import store from "@/store";

export default defineComponent({
  name: "AboutView",
  components: {
    NavBar,
  },
  setup() {
    const isLogged = store.getters.isLogged;

    return {
      isLogged,
    };
  },
});
</script>
