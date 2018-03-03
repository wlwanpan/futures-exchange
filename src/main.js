import Vue from 'vue'
import App from './App'
import Web3 from 'web3'
import router from './router'
import mixins from './js/mixins'

Vue.config.productionTip = false

window.addEventListener('load', function () {
  if (typeof web3 !== 'undefined') {
    console.log('Web3 injected browser: OK.')
    window.web3 = new Web3(window.web3.currentProvider)
  }
  else {
    console.log('Web3 injected browser: Fail. You should consider trying MetaMask.')
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'))
  }

  Vue.mixin(mixins)

  /* eslint-disable no-new */
  new Vue({
    el: '#app',
    router,
    template: '<App/>',
    components: { App }
  })
})
