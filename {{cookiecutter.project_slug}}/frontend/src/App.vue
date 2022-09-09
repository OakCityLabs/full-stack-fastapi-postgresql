<template>
  <div id="app">
    <v-app>
      <v-main v-if="loggedIn === null">
        <v-container fill-height>
          <v-row align="center" justify="center">
            <v-col>
              <div class="text-center">
                <div class="headline my-5">Loading...</div>
                <v-progress-circular
                  size="100"
                  indeterminate
                  color="primary"
                ></v-progress-circular>
              </div>
            </v-col>
          </v-row>
        </v-container>
      </v-main>
      <router-view v-else />
      <NotificationsManager></NotificationsManager>
      <v-snackbar v-model="updateExists" color="primary" :timeout="0">
        New content is available; please refresh.
        <v-btn text @click.native="refreshApp">Refresh</v-btn>
      </v-snackbar>
    </v-app>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import NotificationsManager from "@/components/NotificationsManager.vue";
import { readIsLoggedIn } from "@/store/main/getters";
import { dispatchCheckLoggedIn } from "@/store/main/actions";

@Component({
  components: {
    NotificationsManager,
  },
})
export default class App extends Vue {
  public updateExists = false;
  /* eslint-disable @typescript-eslint/no-explicit-any */
  public registration: any = null;
  public refreshing = false;

  get loggedIn() {
    return readIsLoggedIn(this.$store);
  }

  public async created() {
    // This comes from
    // https://dev.to/drbragg/handling-service-worker-updates-in-your-vue-pwa-1pip
    document.addEventListener("swUpdated", this.updateAvailable, { once: true });
    navigator.serviceWorker.addEventListener("controllerchange", () => {
      if (this.refreshing) return;
      this.refreshing = true;
      // Here the actual reload of the page occurs
      window.location.reload();
    });
    await dispatchCheckLoggedIn(this.$store);
  }

  updateAvailable(event) {
    this.registration = event.detail;
    this.updateExists = true;
  }

  refreshApp() {
    this.updateExists = false;
    // Make sure we only send a 'skip waiting' message if the SW is waiting
    if (!this.registration || !this.registration.waiting) return;
    // Send message to SW to skip the waiting and activate the new SW
    this.registration.waiting.postMessage({ type: "SKIP_WAITING" });
  }
}
</script>
