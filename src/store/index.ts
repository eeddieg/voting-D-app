import { createStore } from "vuex";
import { ethers } from "ethers";

export default createStore({
  state: {
    accounts: [],
    accountsListVisible: false,
    contract: {},
    logged: false,
    provider: null,
    tableVisible: false,
    abi: [
      {
        inputs: [],
        stateMutability: "nonpayable",
        type: "constructor",
      },
      {
        inputs: [
          {
            internalType: "address",
            name: "_voterAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "_pollingStationID",
            type: "uint256",
          },
        ],
        name: "addVoter",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
      },
      {
        inputs: [],
        name: "ballotOwner",
        outputs: [
          {
            internalType: "address",
            name: "",
            type: "address",
          },
        ],
        stateMutability: "view",
        type: "function",
      },
      {
        inputs: [],
        name: "finalResult",
        outputs: [
          {
            internalType: "uint256",
            name: "",
            type: "uint256",
          },
        ],
        stateMutability: "view",
        type: "function",
      },
      {
        inputs: [
          {
            internalType: "uint256",
            name: "",
            type: "uint256",
          },
        ],
        name: "proposals",
        outputs: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "bytes32",
            name: "name",
            type: "bytes32",
          },
          {
            internalType: "uint256",
            name: "voteCount",
            type: "uint256",
          },
        ],
        stateMutability: "view",
        type: "function",
      },
      {
        inputs: [],
        name: "startVote",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
      },
      {
        inputs: [],
        name: "state",
        outputs: [
          {
            internalType: "enum Ballot.State",
            name: "",
            type: "uint8",
          },
        ],
        stateMutability: "view",
        type: "function",
      },
      {
        inputs: [
          {
            internalType: "uint256",
            name: "",
            type: "uint256",
          },
        ],
        name: "stations",
        outputs: [
          {
            internalType: "uint256",
            name: "stationID",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "pplEnrolled",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "votesCasted",
            type: "uint256",
          },
        ],
        stateMutability: "view",
        type: "function",
      },
      {
        inputs: [],
        name: "totalVoters",
        outputs: [
          {
            internalType: "uint256",
            name: "",
            type: "uint256",
          },
        ],
        stateMutability: "view",
        type: "function",
      },
      {
        inputs: [],
        name: "totalVotes",
        outputs: [
          {
            internalType: "uint256",
            name: "",
            type: "uint256",
          },
        ],
        stateMutability: "view",
        type: "function",
      },
      {
        inputs: [
          {
            internalType: "address",
            name: "",
            type: "address",
          },
        ],
        name: "voterRegister",
        outputs: [
          {
            internalType: "bool",
            name: "enrolled",
            type: "bool",
          },
          {
            internalType: "bool",
            name: "voted",
            type: "bool",
          },
          {
            internalType: "int256",
            name: "indexProposal",
            type: "int256",
          },
          {
            internalType: "uint256",
            name: "enrolledPollingStationID",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "votedPollingStationID",
            type: "uint256",
          },
        ],
        stateMutability: "view",
        type: "function",
      },
    ],
  },
  getters: {
    abi(state) {
      return state.abi as ethers.ContractInterface;
    },
    Accounts(state) {
      return state.accounts;
    },
    contract(state) {
      return state.contract;
    },
    isLogged(state) {
      return state.logged;
    },
    isAccountsListVisible(state) {
      return state.accountsListVisible;
    },
    isTableVisible(state) {
      return state.tableVisible;
    },
    Provider(state) {
      return state.provider;
    },
  },
  mutations: {
    setAcounts(state, payload) {
      state.accounts = payload;
    },
    setContract(state, payload) {
      state.contract = payload;
    },
    setAcountsListVisibility(state, payload) {
      state.accountsListVisible = payload;
    },
    setTableVisibility(state, payload) {
      state.tableVisible = payload;
    },
    setConnectionStatus(state, payload) {
      state.logged = payload;
    },
    setProvider(state, payload) {
      state.provider = payload;
    },
  },
  actions: {
    storeAccounts({ commit }, payload) {
      commit("setAcounts", payload);
    },
    storeContract({ commit }, payload) {
      commit("setContract", payload);
    },
    storeProvider({ commit }, payload) {
      commit("setProvider", payload);
    },
    toggleAccountsListVisibility({ commit }, payload) {
      commit("setAcountsListVisibility", payload);
    },
    toggleConnectionStatus({ commit }, payload) {
      commit("setConnectionStatus", payload);
    },
    toggleTableVisibility({ commit }, payload) {
      commit("setTableVisibility", payload);
    },
  },
});
