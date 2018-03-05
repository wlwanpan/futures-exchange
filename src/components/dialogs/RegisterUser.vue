<template>
  <div id="register-user">
    <h1>Register Account</h1>
    <form @submit.prevent="register">

      <div class="label">
        <input v-model="username" placeholder="Enter Username"/>
      </div>
      <div class="label">
        <input v-model="password" placeholder="Enter Password"/>
        <span>{{ isPasswordValid }}</span>
      </div>
      <div class="label">
        <input v-model="confirmPassword" placeholder="Confirm password"/>
        <span>{{ isCPasswordSame }}</span>
      </div>
      <div class="actions">
        <button type="submit">Register</button>
      </div>

    </form>
    <button @click="$emit('close')">Close</button>
  </div>
</template>

<script>

export default {
  data () {
    return {
      username: '',
      password: '',
      confirmPassword: ''
    }
  },

  computed: {
    isUsernameValid: function () {
      return this.username.length > 3
    },

    isPasswordValid: function () {
      return this.password.length > 3
    },

    isCPasswordSame: function () {
      return this.isPasswordValid && this.password === this.confirmPassword
    }
  },

  methods: {
    register: function () {
      this.getGasLimit().then((gasLimit) => {
        var contract = window.MarketPlace.at('0xfb0a4e5bbc481ae30826742c325ac26442cf0253')

        debugger
        contract.registerUser(this.username, this.password, {
          from: '0x00d1ae0a6fc13b9ecdefa118b94cf95ac16d4ab0',
          gas: 500000
        })
        .then(transaction => {
          debugger
        })
        .catch(err => console.log(err))
      })
      .catch(err => console.log(err))
    }
  }
}
</script>

<style lang="scss" scoped>

#register-user {
  text-align: center; padding: 20px;

  .label {
    margin-bottom: 10px;
  }

  input {
    width: 100%;
  }
}

</style>
