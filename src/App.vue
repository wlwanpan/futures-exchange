<template>
  <div id="app">
    <modals-container/>
    <navigation/>
    <statistics/>
    <router-view></router-view>
  </div>
</template>

<script>
import Navigation from '@/components/Navigation'
import Statistics from '@/components/Statistics'

export default {
  name: 'app',
  components: {
    Navigation,
    Statistics
  }
}
</script>

<style lang="scss">

#app {
  text-align: center; height: 100%;
}

</style>
