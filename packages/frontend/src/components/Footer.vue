<template>
  <footer class="footer">
    <div class="footer-links">
      <router-link class="footer-icon" to="/"><Mic :size="14" :stroke-width="1.75" /> 文本转语音</router-link>
      <router-link class="footer-icon" to="/help"><Info :size="14" :stroke-width="1.75" /> 帮助</router-link>
    </div>
    <p>本地文本转语音工具</p>
  </footer>
</template>

<script setup lang="ts">
import { Mic, Info } from 'lucide-vue-next'
</script>

<style scoped lang="less">
.footer {
  text-align: center;
  padding: 28px var(--ev-gutter) calc(32px + var(--ev-safe-bottom));
  font-size: 13px;
  color: var(--ev-text-2);
  line-height: 1.6;
}
.footer p {
  margin: 4px 0 0;
  color: var(--ev-text-2);
  font-size: 13px;
}
.footer-links {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 4px 20px;
  margin-bottom: 6px;
}
.footer-icon {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  min-height: 32px;
  color: var(--ev-text);
  font-size: 13px;
}
.footer a {
  color: var(--ev-accent);
  text-decoration: none;
}
@media @bp-touch {
  .footer-icon {
    min-height: var(--ev-touch);
    padding: 0 6px;
  }
}
</style>
