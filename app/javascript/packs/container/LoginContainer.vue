<template>
  <v-container>
    <form>
      <v-text-field
        v-model="email"
        v-validate="'required|email'"
        :error-messages="errors.collect('email')"
        label="メールアドレス"
        data-vv-name="email"
        required
      ></v-text-field>
      <v-text-field
        v-model="password"
        :append-icon="show ? 'visibility' : 'visibility_off'"
        :type="show ? 'text' : 'password'"
        v-validate="'required|min:8|max:50'"
        :error-messages="errors.collect('password')"
        name="password"
        label="パスワード"
        hint="At least 8 characters"
        counter
        @click:append="show = !show"
      ></v-text-field>

      <v-btn @click="submit" color="#55c500" class="white--text font-weight-bold">ログイン</v-btn>
    </form>
  </v-container>
</template>

<script lang="ts">
import axios from "axios";
import { Vue, Component } from "vue-property-decorator";
import * as VeeValidate from "vee-validate";
import Router from "../router/router";

Vue.use(VeeValidate, { locale: "ja" });

@Component
export default class RegisterContainer extends Vue {
  [x: string]: any;
  $_veeValidate: {
    validator: "new";
  };

  email: string = "";
  show: boolean = false;
  password: string = "";
  dictionary: {
    attributes: {
      email: "Email Addresss";
    };
  };

  mounted() {
    this.$validator.localize("ja", this.dictionary);
  }
  async submit(): Promise<void> {
    // this.$validator.validateAll();

    const params = {
      email: this.email,
      password: this.password
    };

    await axios
      .post("/api/v1/auth/sign_in", params)
      .then(response => {
        localStorage.setItem("access-token", response.headers["access-token"]);
        localStorage.setItem("uid", response.headers["uid"]);
        localStorage.setItem("client", response.headers["client"]);

        Router.push("/");

        // TODO: Vuex でログイン状態を管理するようになったら消す
        window.location.reload();
      })
      .catch(e => {
        // TODO: 適切な Error 表示
        alert(e.response.data.errors.full_messages);
      });
  }
}
</script>

<style lang="scss" scoped>
</style>
