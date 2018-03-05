import { Drizzle, generateStore } from 'drizzle'
import MarketPlace from '../../build/contracts/MarketPlace.json'

export default {

  initDrizzle (state) {
    const options = {
      contracts: [ MarketPlace ]
    }
    const drizzleStore = generateStore(options)
    const drizzle = new Drizzle(options, drizzleStore)
    state.drizzle = drizzle

    var dizzleState = drizzle.store.getState()
    if (dizzleState.drizzleStatus.initialized) {

    }
  }
}
