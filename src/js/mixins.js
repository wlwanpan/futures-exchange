const _ = require('underscore')

var methods = {

  _chain: (input) => _(input).chain(),

  // web3 mixins
  toWei: (input) => window.web3.toWei(input, 'ether'),

  fromWei: (input) => window.web3.fromWei(input, 'ether'),

  getGasLimit: (amountInWei) => {
    return new Promise((resolve, reject) => {
      window.web3.eth.estimateGas({ from: window.web3.eth.accounts[0] },
        (err, result) => {
          const defaultLimit = 500000
          if (err) { reject(err) }
          else { resolve(defaultLimit) }
        }
      )
    })
  }

}

export default { methods }
