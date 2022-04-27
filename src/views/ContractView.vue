<template>
  <NavBar :isLogged="isLogged" />
  <div class="contract" v-show="isLogged">
    <h1>Voting Smart Contract</h1>
    <div class="container">
      <button class="btn btn-outline-primary" @click="callContract">
        Call Contract
      </button>
    </div>
  </div>
  <div class="container">
    <!-- {{ abi }} -->
    <!-- {{ contract }} -->
    <!-- NATA PERASW STA PROPS? -->
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { mapGetters } from "vuex";
import NavBar from "@/components/NavBar.vue";
import store from "@/store";
import { ethers } from "ethers";

export default defineComponent({
  name: "ContractView",
  components: {
    NavBar,
  },
  setup() {
    const isLogged = store.getters.isLogged;

    return {
      isLogged,
    };
  },
  data() {
    return {
      abi: [] as ethers.ContractInterface,
      accountsList: [] as string[],
      contract: {} as ethers.Contract,
    };
  },
  methods: {
    async callContract() {
      try {
        const provider = new ethers.providers.JsonRpcProvider();
        await provider.listAccounts().then((accounts) => {
          this.accountsList = accounts;
        });

        const ownerAddress = this.accountsList[0];

        let signer: ethers.Signer;
        signer = provider.getSigner(ownerAddress);

        let abi = store.getters.abi;

        this.contract = new ethers.Contract(ownerAddress, abi, signer);
      } catch (err) {
        // console.log(err);
      }
    },
  },
});
</script>
