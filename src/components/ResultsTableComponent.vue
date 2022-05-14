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
            <tr scope="row" v-for="(result, index) in outcome" :key="index">
              <!-- <td>{{ result.pollingStationID }}</td>
              <td>{{ result.candidateID }}</td>
              <td>{{ result.votesReceived }}</td>
              <td>{{ result.totalVotes }}</td> -->
            </tr>
          </tbody>
        </table>
        {{ outcome }}
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import store from "@/store";

export default defineComponent({
  name: "ResultsTableComponent",
  data() {
    return {
      outcome: [],
      headers: [
        {
          key: "",
          value: "",
        },
      ],
    };
  },
  mounted() {
    this.init();
  },
  methods: {
    async init() {
      this.outcome = await store.getters.ResultsPerStation;
    },
  },
});
</script>

<style scoped>
.table-responsive {
  max-height: 300px;
}
.table {
  max-height: 450px;
  overflow: auto;
  display: inline-block;
}
</style>
