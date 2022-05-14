<template>
  <div class="container">
    <h1 class="p-3 text-center">Available accounts: {{ accountsNumber }}</h1>
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
      <div class="container">
        <AccountsTableComponent
          :headers="headers"
          :data="accounts"
          :balances="balances"
        />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import store from "@/store";
import { ethers, utils } from "ethers";
import AccountsTableComponent from "./AccountsTableComponent.vue";
import { ContractInfo } from "@/store/contract";

export default defineComponent({
  name: "AccountsComponent",
  components: { AccountsTableComponent },
  data() {
    return {
      accounts: [] as string[],
      accountsVisible: false,
      balances: [] as string[],
      showTable: false,
      tableVisible: false,
      headers: [
        {
          key: "id",
          value: "Account number",
        },
        {
          key: "address",
          value: "Account address",
        },
        {
          key: "balance",
          value: "Balance",
        },
      ],
    };
  },
  props: ["accountsNumber"],
  mounted() {
    const info = new ContractInfo();
    info.getOwner();
    info.getAccounts().then((res: string[]) => {
      this.accounts = res;
    });
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
      const accountsList = store.getters.Accounts;

      const provider = new ethers.providers.JsonRpcProvider();

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
