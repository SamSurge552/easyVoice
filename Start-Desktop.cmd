@echo off
REM Double-click this file (repo root) to open EasyVoice in a desktop window.
REM 双击本文件即可启动 EasyVoice 桌面窗口（无需浏览器）。
setlocal EnableExtensions
cd /d "%~dp0"
chcp 65001 >nul 2>&1

if not exist "scripts\start-desktop.cmd" (
  echo [ERROR] Missing scripts\start-desktop.cmd — is this the EasyVoice repo root?
  echo [错误] 找不到 scripts\start-desktop.cmd，请确认当前目录是 EasyVoice 仓库根目录。
  pause
  exit /b 1
)

call "scripts\start-desktop.cmd"
set "EXITCODE=%ERRORLEVEL%"
if not "%EXITCODE%"=="0" (
  echo.
  echo [ERROR] Desktop launch failed ^(exit %EXITCODE%^). See messages above.
  echo [错误] 桌面启动失败（退出码 %EXITCODE%）。请查看上方提示。
  pause
)
endlocal & exit /b %EXITCODE%
