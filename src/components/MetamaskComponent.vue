<template>
  <NavBar :isLogged="isLogged" />
  <nav class="navbar navbar-expand-lg">
    <div class="container justify-content-between">
      <h3>Welcome to Polling D-app</h3>
      <form class="d-flex">
        <button
          class="btn btn-outline-primary"
          type="button"
          @click="connectToMetaMask"
          v-show="!isLogged"
        >
          Connect to Metamask
        </button>
        <button
          class="btn btn-outline-success"
          type="button"
          @click="logout"
          v-show="isLogged"
        >
          Logout
        </button>
      </form>
    </div>
  </nav>

  <div class="container" v-if="isLogged">
    <AccountsComponent :accounts="accounts" />
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import AccountsComponent from "@/components/AccountsComponent.vue";
import NavBar from "@/components/NavBar.vue";
import store from "@/store";
import { ethers } from "ethers";

declare let window: any;
// declare let web3Provider: any;

export default defineComponent({
  name: "MetaMask",
  props: {
    msg: String,
  },
  components: {
    AccountsComponent,
    NavBar,
  },
  data() {
    return {
      accounts: [],
      isLogged: store.getters.isLogged,
    };
  },
  methods: {
    async connectToMetaMask() {
      if (window.ethereum) {
        console.log("MetaMask is installed!");
      } else {
        console.log("Please install MetaMask");
      }
      const provider = new ethers.providers.JsonRpcProvider();

      console.log("Logged in.");
      store.dispatch("toggleConnectionStatus", true);
      this.isLogged = true;
      store.dispatch("storeAccounts", await provider.listAccounts());
      this.accounts = store.getters.Accounts;
    },
    async logout() {
      console.log("Logged out.");
      this.isLogged = false;
      store.dispatch("toggleConnectionStatus", false);
      store.dispatch("storeProvider", null);
      this.accounts = [];
    },
  },
});
</script>
