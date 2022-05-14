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
            <tr scope="row" v-for="(voter, index) in data" :key="index">
              <td>{{ index + 1 }}</td>
              <td>{{ voter.isEnrolled ? "YES" : "NO" }}</td>
              <td>{{ voter.hasVoted ? "YES" : "NO" }}</td>
              <td>{{ voter.enrolledPollingStationID }}</td>
              <td>{{ voter.votedPollingStationID }}</td>
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
  name: "VoterTableComponent",
  props: ["headers", "data"],
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
