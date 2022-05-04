<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light" v-show="!isLogged">
    <div class="container-fluid">
      <router-link class="navbar-brand" to="/">Polling D-app</router-link>
      <div class="collapse navbar-collapse" id="navbarNav"></div>
    </div>
  </nav>
  <nav class="navbar navbar-expand-lg navbar-light bg-light" v-show="isLogged">
    <div class="container-fluid">
      <router-link class="navbar-brand" to="/accounts"
        >Polling D-app</router-link
      >
      <div
        class="collapse navbar-collapse justify-content-center"
        id="navbarNav"
      >
        <ul class="navbar-nav">
          <li class="nav-item">
            <router-link
              class="nav-link ms-5 me-5"
              aria-current="page"
              to="/accounts"
            >
              Accounts
            </router-link>
          </li>
          <li class="nav-item">
            <router-link class="nav-link me-5" to="/ballot">
              Ballot
            </router-link>
          </li>
          <li class="nav-item">
            <router-link class="nav-link me-5" to="/voters">
              Voters
            </router-link>
          </li>
          <li class="nav-item">
            <router-link class="nav-link me-5" to="/pollingStations">
              Polling Stations
            </router-link>
          </li>
          <li class="nav-item">
            <router-link class="nav-link me-5" to="/voting">Vote</router-link>
          </li>
          <li class="nav-item">
            <router-link class="nav-link me-5" to="/contract">
              Smart Contract Info
            </router-link>
          </li>
          <li class="nav-item">
            <router-link class="nav-link" to="/about">About</router-link>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  name: "NavBar",
  props: {
    isLogged: Boolean,
  },
});
</script>
