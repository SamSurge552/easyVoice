#!/usr/bin/env bash
# Double-click / terminal launcher for the EasyVoice desktop window (Linux / macOS).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v pnpm >/dev/null 2>&1; then
  if command -v corepack >/dev/null 2>&1; then
    corepack enable
  else
    echo "pnpm is required. Install Node.js 20+ and run: corepack enable" >&2
    exit 1
  fi
fi

if [[ ! -d node_modules ]]; then
  echo "Installing dependencies..."
  pnpm i -r
fi

if [[ ! -f packages/backend/dist/server.js ]]; then
  echo "Building EasyVoice..."
  pnpm build
fi

exec pnpm desktop
