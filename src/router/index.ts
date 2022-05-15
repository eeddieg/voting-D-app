import { createRouter, createWebHistory, RouteRecordRaw } from "vue-router";
import HomeView from "../views/HomeView.vue";
import store from "@/store";

const routes: Array<RouteRecordRaw> = [
  {
    path: "/",
    name: "home",
    component: HomeView,
    meta: {
      title: "Voting D-app",
    },
  },
  {
    path: "/accounts",
    name: "accounts",
    component: () =>
      import(/* webpackChunkName: "accounts" */ "../views/AccountsView.vue"),
    meta: {
      requiresAuth: true,
      title: "Voting D-app - Accounts",
    },
  },
  {
    path: "/ballot",
    name: "ballot",
    component: () =>
      import(/* webpackChunkName: "ballot" */ "../views/BallotView.vue"),
    meta: {
      requiresAuth: true,
      title: "Voting D-app - Ballot",
    },
  },
  {
    path: "/voters",
    name: "voters",
    component: () =>
      import(/* webpackChunkName: "voters" */ "../views/VotersView.vue"),
    meta: {
      requiresAuth: true,
      title: "Voting D-app - Voter Registry",
    },
  },
  {
    path: "/pollingStations",
    name: "pollingStations",
    component: () =>
      import(
        /* webpackChunkName: "pollingStations" */ "../views/PollingStationView.vue"
      ),
    meta: {
      requiresAuth: true,
      title: "Voting D-app - Polling Stations",
    },
  },
  {
    path: "/contract",
    name: "contract",
    component: () =>
      import(/* webpackChunkName: "contract" */ "../views/ContractView.vue"),
    meta: {
      requiresAuth: true,
      title: "Voting D-app - Contract Info",
    },
  },
  {
    path: "/voting",
    name: "voting",
    component: () =>
      import(/* webpackChunkName: "voting" */ "../views/VotingView.vue"),
    meta: {
      requiresAuth: true,
      title: "Voting D-app - Voting",
    },
  },
  {
    path: "/about",
    name: "about",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/AboutView.vue"),
    meta: {
      requiresAuth: true,
      title: "Voting D-app",
    },
  },
  {
    path: "/:catchAll(.*)",
    name: "404",
    component: HomeView,
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

router.beforeEach((to, from, next) => {
  if (to.matched.some((record) => record.meta.requiresAuth)) {
    const isLogged = store.getters.isLogged;
    if (!isLogged) {
      next({ name: "home" });
    } else {
      next();
    }
  } else {
    next();
  }
});

export default router;
