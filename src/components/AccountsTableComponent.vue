<template>
  <div class="container">
    <div id="table" class="row justify-content-center mt-3">
      <h2>Table</h2>
      <div class="col-auto">
        <table class="table table-responsive table-striped w-auto">
          <thead>
            <tr>
              <th scope="row" v-for="field in headers" :key="field.key">
                {{ field.value }}
              </th>
            </tr>
          </thead>
          <tbody>
            <tr scope="row" v-for="(account, index) in data" :key="index">
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

export default defineComponent({
  name: "AccountsTableComponent",
  props: ["headers", "data", "balances"],
});
</script>

<style scoped>
.table-responsive {
  max-height: 350px;
}
.table {
  max-height: 450px;
  overflow: auto;
  display: inline-block;
}
</style>
