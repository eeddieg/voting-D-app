<template>
  <div class="container">
    <div id="table" class="row justify-content-center mt-3">
      <h2>Results Per Polling Station</h2>
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
            <tr scope="row" v-for="(item, index) in data" :key="index">
              <td>{{ item.stationID }}</td>
              <td
                scope="row"
                v-for="(votes, index) in item.results"
                :key="index"
              >
                {{ votes }}
              </td>
              <td>{{ item.totalVotes }}</td>
            </tr>
            <tr scope="row">
              <td></td>
              <td scope="row" v-for="id in counter" :key="id">
                <strong>{{ sumVotes(id) }}</strong>
              </td>
              <td>
                <strong>{{ totalVotes }}</strong>
              </td>
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

export default defineComponent({
  name: "ResultsTableComponent",
  props: ["headers", "data", "counter", "totalVotes"],
  data() {
    return {
      candidates: store.getters.candidates,
    };
  },
  methods: {
    sumVotes(candidateId: number) {
      let counter = 0;
      const data = this.$props.data;

      for (let i = 0; i < data.length; i++) {
        const results = data[i].results;
        for (let j = 0; j < results.length; j++) {
          //IDs start for 1, array from 0
          if (j == candidateId - 1) {
            counter += results[j];
          }
        }
      }
      return counter;
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
table tr > td:first-child {
  border-right: 1px solid black;
}
table tr > td:last-child {
  border-left: 1px solid black;
}
</style>
