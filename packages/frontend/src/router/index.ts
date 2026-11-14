import { createWebHistory, createRouter } from 'vue-router'

import Generate from '@/views/Generate.vue'
import Help from '@/views/Help.vue'
import NotFound from '@/views/NotFound.vue'

const routes = [
  { path: '/', component: Generate },
  { path: '/generate', redirect: '/' },
  { path: '/help', component: Help },
  { path: '/about', redirect: '/help' },
  { path: '/home', redirect: '/' },
  { path: '/:pathMatch(.*)*', name: 'NotFound', component: NotFound },
]

export const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  },
})
