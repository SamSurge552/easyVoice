<template>
  <div class="not-found-container">
    <header class="header">
      <h1 class="title">404</h1>
      <p class="subtitle">哎呀！页面走丢了</p>
      <div class="header-actions">
        <el-button type="primary" round @click="goToGenerate">
          <Mic class="icon" /> 返回文本转语音
        </el-button>
      </div>
    </header>

    <section class="info">
      <p class="hint">地址可能输入有误，或该页面已移除。</p>
      <p class="cta">
        <router-link to="/">点此回到文本转语音</router-link>
      </p>
    </section>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import { Mic } from 'lucide-vue-next'

const router = useRouter()

const goToGenerate = () => {
  router.push('/')
}
</script>

<style scoped lang="less">
.not-found-container {
  max-width: 720px;
  margin: 0 auto;
}

.header {
  text-align: center;
  padding: clamp(40px, 9vw, 64px) 0 clamp(20px, 4vw, 32px);
}
.title {
  font-size: clamp(56px, 12vw, 72px);
  font-weight: 700;
  letter-spacing: -0.03em;
  margin: 0 0 8px;
  color: var(--ev-text);
}
.subtitle {
  font-size: clamp(17px, 3vw, 24px);
  color: #666;
  margin: 0 0 24px;
}
.header-actions {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 12px;
}
.header-actions .el-button {
  margin: 0;
  height: 44px;
  padding: 0 24px;
  font-size: 15px;
}
.icon {
  width: 18px;
  height: 18px;
  margin-right: 6px;
  vertical-align: middle;
}

.info {
  text-align: center;
  margin: 0 auto clamp(40px, 8vw, 60px);
}
.hint {
  font-size: 15px;
  color: var(--ev-text-2);
  margin: 0 0 12px;
}
.cta {
  margin: 0;
  font-size: 15px;
}
.cta a {
  color: var(--ev-accent);
  display: inline-flex;
  align-items: center;
  min-height: var(--ev-touch);
}
</style>
