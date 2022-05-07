<template>
  <MetamaskComponent />
  <div class="container" v-if="isLogged">
    <AccountsComponent :accountsNumber="accountsNumber" />
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import AccountsComponent from "@/components/AccountsComponent.vue"; // @ is an alias to /src
import MetamaskComponent from "@/components/MetamaskComponent.vue";
import store from "@/store";

export default defineComponent({
  name: "AccountsView",
  components: {
    AccountsComponent,
    MetamaskComponent,
  },
  data() {
    return {
      accounts: [] as string[],
      accountsNumber: store.getters.numberOfAccounts,
      isLogged: store.getters.isLogged,
    };
  },
});
</script>
