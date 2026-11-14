import { test, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import Help from '@/views/Help.vue'

test('renders FAQ help surface', () => {
  const wrapper = mount(Help, {
    global: {
      stubs: {
        'el-collapse': true,
        'el-collapse-item': true,
        'router-link': { template: '<a><slot /></a>' },
      },
    },
  })
  expect(wrapper.text()).toContain('帮助')
  expect(wrapper.text()).toContain('常见问题')
})
