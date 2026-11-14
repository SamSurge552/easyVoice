@echo off
REM Double-click launcher for the EasyVoice desktop window (Windows).
REM Windows 桌面启动脚本（由仓库根目录 Start-Desktop.cmd 调用）。
setlocal
cd /d "%~dp0.."

where pnpm >nul 2>&1
if errorlevel 1 (
  where corepack >nul 2>&1
  if errorlevel 1 (
    echo [ERROR] pnpm is required. Install Node.js 20+ then run: corepack enable
    echo [错误] 需要 pnpm。请先安装 Node.js 20+，然后执行: corepack enable
    exit /b 1
  )
  call corepack enable
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
