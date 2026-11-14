const { app, BrowserWindow, shell } = require('electron')
const { spawn } = require('child_process')
const http = require('http')
const path = require('path')
const fs = require('fs')

const PORT = Number(process.env.PORT || 3000)
const HOST = process.env.EASYVOICE_HOST || '127.0.0.1'
const HEALTH_PATH = '/api/health'
const UI_URL =
  process.env.EASYVOICE_UI_URL ||
  (process.env.EASYVOICE_DESKTOP_DEV === '1'
    ? `http://${HOST}:5173`
    : `http://${HOST}:${PORT}`)

/** @type {import('child_process').ChildProcess | null} */
let backendProcess = null
let stopping = false

function repoRoot() {
  // packages/desktop -> monorepo root (works for pnpm start / electron .)
  return path.resolve(__dirname, '..', '..')
}

function backendEntry(root) {
  return path.join(root, 'packages', 'backend', 'dist', 'server.js')
}

function isServerUp() {
  return new Promise((resolve) => {
    const req = http.get(
      {
        host: HOST,
        port: PORT,
        path: HEALTH_PATH,
        timeout: 1500,
      },
      (res) => {
        res.resume()
        resolve(res.statusCode === 200)
      }
    )
    req.on('error', () => resolve(false))
    req.on('timeout', () => {
      req.destroy()
      resolve(false)
    })
  })
}

async function waitForServer(timeoutMs = 60000) {
  const start = Date.now()
  while (Date.now() - start < timeoutMs) {
    if (await isServerUp()) return true
    await new Promise((r) => setTimeout(r, 400))
  }
  return false
}

function startBackend(root) {
  const entry = backendEntry(root)
  if (!fs.existsSync(entry)) {
    throw new Error(
      `Backend build missing: ${entry}\nRun \`pnpm build\` from the repo root first.`
    )
  }

  // Always spawn with Node — under Electron, process.execPath is the Electron
  // binary and would not correctly run the Express server.
  // Prefer PATH `node` (set NODE_BINARY to override). Do not use shell:true:
  // npm_node_execpath is often `C:\Program Files\nodejs\node.exe`, which cmd.exe
  // splits on the space and fails with "'C:\Program' is not recognized".
  const nodeBin = process.env.NODE_BINARY || 'node'
  const child = spawn(nodeBin, [entry], {
    cwd: root,
    env: {
      ...process.env,
      PORT: String(PORT),
      NODE_ENV: 'production',
      MODE: 'production',
    },
    stdio: 'inherit',
    windowsHide: true,
  })

  child.on('exit', (code, signal) => {
    backendProcess = null
    if (!stopping && code && code !== 0) {
      console.error(`EasyVoice backend exited (code=${code}, signal=${signal})`)
    }
  })

  backendProcess = child
  return child
}

function stopBackend() {
  stopping = true
  if (!backendProcess || backendProcess.killed) return
  const child = backendProcess
  backendProcess = null
  try {
    if (process.platform === 'win32') {
      spawn('taskkill', ['/pid', String(child.pid), '/f', '/t'])
    } else {
      child.kill('SIGTERM')
      setTimeout(() => {
        if (!child.killed) child.kill('SIGKILL')
      }, 3000)
    }
  } catch (err) {
    console.error('Failed to stop backend:', err)
  }
}

function createWindow() {
  const win = new BrowserWindow({
    width: 1280,
    height: 840,
    minWidth: 960,
    minHeight: 640,
    title: 'EasyVoice',
    show: false,
    autoHideMenuBar: true,
    webPreferences: {
      preload: path.join(__dirname, 'preload.cjs'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: true,
    },
  })

  win.once('ready-to-show', () => win.show())

  win.webContents.setWindowOpenHandler(({ url }) => {
    shell.openExternal(url)
    return { action: 'deny' }
  })

  win.loadURL(UI_URL)
  return win
}

async function bootstrap() {
  const root = process.env.EASYVOICE_ROOT
    ? path.resolve(process.env.EASYVOICE_ROOT)
    : repoRoot()

  const alreadyUp = await isServerUp()
  if (!alreadyUp) {
    if (process.env.EASYVOICE_DESKTOP_DEV === '1' && process.env.EASYVOICE_UI_URL) {
      // Dev UI only; caller is expected to run backend separately if needed.
    } else if (process.env.EASYVOICE_DESKTOP_DEV === '1') {
      // Vite UI on :5173; still need API on :3000 — start production backend if built,
      // otherwise ask the user to run `pnpm --filter @easy-voice/backend dev`.
      try {
        startBackend(root)
      } catch (err) {
        console.warn(String(err.message || err))
        console.warn('Start the backend with `pnpm --filter @easy-voice/backend dev` and retry.')
      }
    } else {
      startBackend(root)
    }

    const ok = await waitForServer()
    if (!ok && process.env.EASYVOICE_DESKTOP_DEV !== '1') {
      throw new Error(
        `Timed out waiting for EasyVoice backend at http://${HOST}:${PORT}${HEALTH_PATH}`
      )
    }
  }

  createWindow()
}

app.whenReady().then(() =>
  bootstrap().catch((err) => {
    console.error(err)
    app.quit()
  })
)

app.on('window-all-closed', () => {
  stopBackend()
  if (process.platform !== 'darwin') app.quit()
})

app.on('before-quit', () => {
  stopBackend()
})

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    bootstrap().catch((err) => {
      console.error(err)
      app.quit()
    })
  }
})
