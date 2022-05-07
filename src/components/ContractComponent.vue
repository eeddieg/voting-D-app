<template>
  <div class="container">
    <h1 class="p-3 text-center">Voting Smart Contract</h1>

    <div class="container mt-3 mb-3">
      <h2>Contract Address</h2>
      {{ contractAddress }}
    </div>
    <div class="container mt-4 mb-3">
      <h2>ABI</h2>
      <div id="table" class="row justify-content-center mt-3">
        <div class="col-auto">
          <table class="table table-responsive table-striped w-auto">
            <tbody>
              <tr
                scope="row"
                v-for="(value, option, index) in abi"
                :key="index"
              >
                <td>
                  <strong>{{ option }}: </strong>{{ value }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import store from "@/store";

export default defineComponent({
  name: "ContractComponent",
  data() {
    return {
      abi: store.getters.ABI,
      contractAddress: store.getters.ContractAddress,
    };
  },
  setup() {
    const isLogged = store.getters.isLogged;
    return {
      isLogged,
    };
  },
});
</script>
