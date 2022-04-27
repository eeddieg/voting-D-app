<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light" v-show="!isLogged">
    <div class="container-fluid">
      <router-link class="navbar-brand" to="/">Polling D-app</router-link>
      <div class="collapse navbar-collapse" id="navbarNav"></div>
    </div>
  </nav>
  <nav class="navbar navbar-expand-lg navbar-light bg-light" v-show="isLogged">
    <div class="container-fluid">
      <router-link class="navbar-brand" to="/">Polling D-app</router-link>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav">
          <li class="nav-item">
            <router-link class="nav-link active" aria-current="page" to="/"
              >Accounts</router-link
            >
          </li>
          <li class="nav-item">
            <router-link class="nav-link" to="/contract">Poll</router-link>
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
