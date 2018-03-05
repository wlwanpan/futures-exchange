<template>
  <div id="dashboard">
    <h1>{{ msg }}</h1>
  </div>
</template>

<script>
import RegisterUser from '@/components/dialogs/RegisterUser'

export default {
  name: 'dashboard',
  data () {
    return {
      msg: 'Futures Market'
    }
  },
  mounted () {
    console.log('dashboard mounted')
    this.$modal.show(
      RegisterUser,
      {
        title: 'Register User'
      },
      {
        adaptive: true
      }
    )
  }
}
</script>

<style lang="scss" scoped>

#dashboard {

}

</style>
