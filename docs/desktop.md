# EasyVoice Desktop App

Run EasyVoice in a **desktop window** (Electron), without opening a browser.

## Why Electron

The project is already a Node.js + Vue + Express monorepo. Electron is the smallest reliable shell: it can spawn the existing Express backend and load the built Vue UI in a native window. Tauri would need a Rust toolchain and still require a separate Node process for the backend, so it is a larger change for the same UI.

## Prerequisites

- **Node.js ≥ 20**
- **pnpm** (`corepack enable` or `npm install -g pnpm`)
- OS: **Linux / macOS / Windows** (Electron supports all three)
- Optional: ffmpeg on `PATH` (same as the Node server for audio processing)

## Install & build

From the repository root:

```bash
corepack enable
pnpm i -r
pnpm build
```

`pnpm build` compiles the backend and copies the Vue UI into `packages/backend/public/`. The desktop shell serves that UI through the backend on port `3000` (override with `PORT`).

## Start the desktop app

### Recommended (any OS)

```bash
pnpm desktop
```

This opens an Electron window and starts the backend if nothing is already listening on the health endpoint (`http://127.0.0.1:3000/api/health`). If you already ran `pnpm start`, the window reuses that server.

### Double-click / OS launchers

| OS | Launcher |
|----|----------|
| Linux / macOS | `scripts/start-desktop.sh` (mark executable once: `chmod +x scripts/start-desktop.sh`) |
| Windows | `scripts/start-desktop.cmd` |

These scripts `cd` to the repo root, ensure dependencies/build when needed, then run `pnpm desktop`.

### Dev shell (optional)

Hot-reload the Vue UI with Vite while using the Electron window:

```bash
# terminal 1 — Vite + backend (or backend alone)
pnpm dev

# terminal 2 — Electron loads http://127.0.0.1:5173
pnpm desktop:dev
```

## Packaged builds (optional)

From `packages/desktop` after a root `pnpm build` and `pnpm i -r`:

```bash
pnpm --filter @easy-voice/desktop pack   # unpacked app under packages/desktop/release/
pnpm --filter @easy-voice/desktop dist   # platform installers (AppImage / dmg / nsis)
```

**Note:** Packaged Electron binaries still expect the monorepo backend build next to them for full TTS (set `EASYVOICE_ROOT` to the repo root if you move the app). The supported day-to-day path is `pnpm desktop` from a cloned repo.

## Environment

| Variable | Meaning |
|----------|---------|
| `PORT` | Backend port (default `3000`) |
| `EASYVOICE_ROOT` | Override monorepo root when spawning the backend |
| `EASYVOICE_UI_URL` | Override the URL loaded in the window |
| `EASYVOICE_DESKTOP_DEV=1` | Load Vite (`http://127.0.0.1:5173`) instead of the production UI |

## Troubleshooting

- **“Backend build missing”** — run `pnpm build` at the repo root.
- **“Electron failed to install correctly”** — pnpm must run Electron’s download script. From the repo root: `pnpm rebuild electron`. The root `package.json` lists `electron` under `pnpm.onlyBuiltDependencies` so a normal `pnpm i -r` should fetch the binary.
- **Window opens blank / timed out** — check that port `3000` is free or set `PORT`, and that `packages/backend/public` contains the built UI.
- **Still want the browser UI** — `pnpm start` then open `http://localhost:3000` as before; desktop is optional.
