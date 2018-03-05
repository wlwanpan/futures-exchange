import Vue from 'vue'
import Vuex from 'Vuex'
import actions from './actions'
import mutations from './mutations'

Vue.use(Vuex)

const state = {
  dizzle: null,
  contract: {
    address: '0xfb0a4e5bbc481ae30826742c325ac26442cf0253'
  },
  account: {
    address: '0x00d1ae0a6fc13b9ecdefa118b94cf95ac16d4ab0',
    balance: 0
  }
}
const getters = {}

export default new Vuex.Store({
  state,
  getters,
  mutations,
  actions
})
