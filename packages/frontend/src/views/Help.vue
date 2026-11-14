<template>
  <div class="help-container">
    <header class="header">
      <h1 class="title">帮助</h1>
      <p class="subtitle">常见问题与使用提示</p>
    </header>

    <section class="faq">
      <el-collapse accordion>
        <el-collapse-item title="如何自定义语音角色？">
          <p>
            在生成页面选择不同的语音角色，并调整语速、音调等参数；也可以通过 AI
            智能推荐最适合的配置。
          </p>
        </el-collapse-item>
        <el-collapse-item title="为什么我的 AI 配音效果不好？">
          <p>
            AI 推荐配音由大模型决定各段落参数，<strong>大模型能力直接影响结果</strong>。可尝试更换模型，或改用
            Edge-TTS 固定声音配音。
          </p>
        </el-collapse-item>
        <el-collapse-item title="长文本速度太慢？">
          <p>
            请先确认网络状况（Edge-TTS 依赖网络请求）。AI 推荐还需分段、分析与拼接，通常比固定声音慢。可换更快的大模型，或在
            `.env` 中适当提高 <code>EDGE_API_LIMIT</code>（建议 10
            以下），<strong>并发过高可能触发限制</strong>。
          </p>
        </el-collapse-item>
        <el-collapse-item title="如何配置 AI 推荐？">
          <p>
            在 <code>.env</code> 或 <code>packages/backend/.env</code> 中配置
            <code>OPENAI_API_KEY</code>、<code>OPENAI_BASE_URL</code>、<code>MODEL_NAME</code>。也可使用任意
            OpenAI 兼容接口。
          </p>
        </el-collapse-item>
      </el-collapse>
    </section>

    <p class="back">
      <router-link to="/">返回文本转语音</router-link>
    </p>
  </div>
</template>

<script setup lang="ts"></script>

<style scoped lang="less">
.help-container {
  max-width: 800px;
  margin: 0 auto;
}

.header {
  text-align: center;
  padding: clamp(28px, 6vw, 48px) 0 clamp(16px, 3vw, 28px);
}
.title {
  font-size: clamp(26px, 5vw, 36px);
  font-weight: 700;
  letter-spacing: -0.02em;
  margin: 0 0 8px;
  color: var(--ev-text);
}
.subtitle {
  margin: 0;
  font-size: 15px;
  color: var(--ev-text-2);
}

.faq {
  margin: 0 auto clamp(24px, 5vw, 40px);
}
.el-collapse {
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.9);
  padding: 4px 12px;
  border: 0;
}
.faq :deep(.el-collapse-item__header) {
  font-size: 15px;
  color: var(--ev-text);
  height: auto;
  min-height: 52px;
  line-height: 1.5;
  padding: 14px 4px;
  text-align: left;
}
.faq :deep(.el-collapse-item__content) {
  font-size: 14px;
  color: var(--ev-text-2);
  line-height: 1.7;
  padding: 0 4px 18px;
}
.faq :deep(.el-collapse-item__content p) {
  margin: 0;
}
.faq :deep(code) {
  font-size: 0.92em;
  padding: 0 4px;
  border-radius: 4px;
  background: rgba(0, 0, 0, 0.05);
}

.back {
  text-align: center;
  margin: 0 0 clamp(32px, 6vw, 48px);
  font-size: 14px;
}
.back a {
  color: var(--ev-accent);
}
</style>
