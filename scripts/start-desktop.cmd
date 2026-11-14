@echo off
REM Double-click launcher for the EasyVoice desktop window (Windows).
setlocal
cd /d "%~dp0.."

where pnpm >nul 2>&1
if errorlevel 1 (
  where corepack >nul 2>&1
  if errorlevel 1 (
    echo pnpm is required. Install Node.js 20+ and run: corepack enable
    exit /b 1
  )
  call corepack enable
)

if not exist "node_modules\" (
  echo Installing dependencies...
  call pnpm i -r
  if errorlevel 1 exit /b 1
)

if not exist "packages\backend\dist\server.js" (
  echo Building EasyVoice...
  call pnpm build
  if errorlevel 1 exit /b 1
)

call pnpm desktop
endlocal
