import Vue from 'vue'
import App from './App'
import router from './router'
import store from './store/store'
import VModal from 'vue-js-modal'
import mixins from './js/mixins'

import Web3 from 'web3'
import TruffleContract from 'truffle-contract'
import MarketPlaceContract from '@contracts/MarketPlace.json'

Vue.config.productionTip = false
Vue.use(VModal, { dynamic: true })

window.addEventListener('load', function () {
  if (typeof web3 !== 'undefined') {
    console.log('Web3 injected browser: OK.')
    window.web3 = new Web3(window.web3.currentProvider)
  }
  else {
    console.log('Web3 injected browser: Fail. You should consider trying MetaMask.')
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'))
  }

  window.MarketPlace = TruffleContract(MarketPlaceContract)
  window.MarketPlace.setProvider(window.web3.currentProvider)

  store.dispatch('initDrizzle')

  Vue.mixin(mixins)

  /* eslint-disable no-new */
  new Vue({
    el: '#app',
    router,
    store,
    template: '<App/>',
    components: { App }
  })
})
