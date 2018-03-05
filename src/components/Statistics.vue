<template>
  <div id="statistics">
    Statistics bar
  </div>
</template>

<script>
export default {
  name: 'statistics',
  mounted () {
    console.log('statistics mounted')
  }
}
</script>

<style lang="scss" scoped>

#statistics {
  height: 40px;
  border: 1px solid black;
}

</style>
