<template>
  <div class="dashboard">
    <h1>{{ msg }}</h1>
  </div>
</template>

<script>
export default {
  name: 'dashboard',
  data () {
    return {
      msg: 'Welcome to your truffle-vue dApp'
    }
  },
  mounted () {
    console.log('dashboard mounted')
    debugger
  }
}
</script>

<style lang="scss" scoped>
h1, h2 {
  font-weight: normal;
  display: block;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}
</style>
