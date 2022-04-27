<template>
  <div class="container">
    <h3 class="p-3 text-center">Available accounts: {{ accounts.length }}</h3>
    <button
      class="btn btn-outline-primary"
      v-show="!accountsVisible"
      @click="toggleAccounts"
    >
      Show Accounts
    </button>
    <button
      class="btn btn-outline-primary"
      v-show="accountsVisible"
      @click="toggleAccounts"
    >
      Hide Accounts
    </button>
    <div
      id="table"
      class="row justify-content-center mt-3"
      v-show="tableVisible"
    >
      <div class="col-auto">
        <table class="table table-responsive table-striped w-auto">
          <thead>
            <tr>
              <th>Account number</th>
              <th>Account address</th>
              <th>Balance</th>
            </tr>
          </thead>
          <tbody>
            <tr scope="row" v-for="(account, index) in accounts" :key="index">
              <td>{{ index + 1 }}</td>
              <td>{{ account }}</td>
              <td>{{ balances[index] }} ETH</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import store from "@/store";
import { ethers, utils } from "ethers";

export default defineComponent({
  name: "AccountsComponent",
  props: {
    accounts: {
      type: Array,
    },
  },
  data() {
    return {
      showTable: false,
      accountsVisible: false,
      tableVisible: false,
      balances: [] as string[],
    };
  },
  methods: {
    toggleAccounts() {
      this.accountsVisible = !this.accountsVisible;
      this.tableVisible = !this.tableVisible;
      store.dispatch("toggleAccountsListVisibility", this.accountsVisible);
      store.dispatch("toggleTableVisibility", this.tableVisible);
      this.getBalance();
    },
    async getBalance() {
      let accountsList: any = null;
      const provider = new ethers.providers.JsonRpcProvider();
      await provider.listAccounts().then((accounts) => {
        accountsList = accounts;
      });
      for (let accIndex in accountsList) {
        const index = +accIndex;
        const acc = accountsList[index];
        await provider.getBalance(acc).then((res) => {
          const bal = utils.formatEther(res);
          this.balances[index] = bal;
        });
      }
    },
  },
});
</script>

<style></style>
