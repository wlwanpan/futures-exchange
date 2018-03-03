const _ = require('underscore')

var methods = {

  _chain: (input) => _(input).chain(),
  // web3 mixins
  toWei: (input) => window.web3.toWei(input, 'ether'),

  fromWei: (input) => window.web3.fromWei(input, 'ether')


}

export default { methods }
