@echo off
REM Double-click launcher for the EasyVoice desktop window (Windows).
REM Windows 桌面启动脚本（由仓库根目录 Start-Desktop.cmd 调用）。
setlocal EnableExtensions
cd /d "%~dp0.."

REM Prefer UTF-8 so Chinese messages render correctly in modern Windows consoles.
chcp 65001 >nul 2>&1

REM Ensure Node / npm-global pnpm are on PATH (fresh installs may not be in this session yet).
if exist "%ProgramFiles%\nodejs\node.exe" set "PATH=%ProgramFiles%\nodejs;%PATH%"
if exist "%LOCALAPPDATA%\Programs\node\node.exe" set "PATH=%LOCALAPPDATA%\Programs\node;%PATH%"
if exist "%APPDATA%\npm\pnpm.cmd" set "PATH=%APPDATA%\npm;%PATH%"

REM Electron binary download often times out from GitHub in CN; npmmirror is reliable.
if not defined ELECTRON_MIRROR set "ELECTRON_MIRROR=https://npmmirror.com/mirrors/electron/"

where pnpm >nul 2>&1
if errorlevel 1 (
  where corepack >nul 2>&1
  if not errorlevel 1 (
    call corepack enable >nul 2>&1
    call corepack prepare pnpm@10.6.3 --activate >nul 2>&1
  )
)

where pnpm >nul 2>&1
if errorlevel 1 (
  where npm >nul 2>&1
  if not errorlevel 1 (
    echo Installing pnpm via npm... / 正在通过 npm 安装 pnpm...
    call npm install -g pnpm@10.6.3
    if exist "%APPDATA%\npm\pnpm.cmd" set "PATH=%APPDATA%\npm;%PATH%"
  )
)

where pnpm >nul 2>&1
if errorlevel 1 (
  echo [ERROR] pnpm is required. Install Node.js 20+ from https://nodejs.org then reopen this window.
  echo [错误] 需要 pnpm。请先安装 Node.js 20+（https://nodejs.org），关闭本窗口后重新双击启动。
  echo         Or run: npm install -g pnpm
  echo         或执行: npm install -g pnpm
  exit /b 1
)

if not exist "node_modules\" (
  echo Installing dependencies... / 正在安装依赖...
  call pnpm i -r
  if errorlevel 1 (
    echo [ERROR] pnpm i -r failed.
    echo [错误] 依赖安装失败。
    exit /b 1
  )
)

if not exist "packages\backend\dist\server.js" (
  echo Building EasyVoice... / 正在构建...
  call pnpm build
  if errorlevel 1 (
    echo [ERROR] pnpm build failed. Fix build errors and retry.
    echo [错误] 构建失败，请根据上方日志修复后重试。
    exit /b 1
  )
)

echo Starting EasyVoice desktop... / 正在启动桌面窗口...
call pnpm desktop
set "EXITCODE=%ERRORLEVEL%"
endlocal & exit /b %EXITCODE%
