<template>
  <Layout>
    <template>
      <div class="">test</div>
    </template>
  </Layout>
</template>

<script>
import Layout from "@vuepress/theme-default/lib/client/layouts/Layout.vue";

export default {
  components: {
    Layout,
  },
  mounted() {
    if (document.getElementById("betaBadge")) return;
    const header = document.querySelector("[aria-label$=BETA]");
    // console.log(header)
    if (header?.innerHTML) {
      header.innerHTML = header.innerHTML.replace(
        "BETA",
        '<span id="betaBadge" class="badge tip" style="vertical-align: top;">BETA</span>'
      );
    }
  },
};
</script>

<style lang="scss">
</style>