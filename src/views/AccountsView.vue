<template>
  <Metamask />
  <div class="container" v-if="isLogged">
    <AccountsComponent :accountsNumber="accountsNumber" />
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import AccountsComponent from "@/components/AccountsComponent.vue"; // @ is an alias to /src
import Metamask from "@/components/MetamaskComponent.vue";
import NavBar from "@/components/NavBar.vue"; // @ is an alias to /src
import store from "@/store";

export default defineComponent({
  name: "HomeView",
  components: {
    AccountsComponent,
    Metamask,
  },
  data() {
    return {
      accounts: [] as string[],
      accountsNumber: 0,
      isLogged: store.getters.isLogged,
    };
  },
});
</script>
