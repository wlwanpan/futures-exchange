<template>
  <div id="navigation">
    nav bar
  </div>
</template>

<script>
export default {
  name: 'navigation',
  mounted () {
    console.log('navigation mounted')
  }
}
</script>

<style lang="scss" scoped>

#navigation {
  height: 60px;
  background-color: $dark-chocolate;
}

</style>
