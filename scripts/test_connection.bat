@echo off
echo ===================================================
echo   Zepto MCP Server - Connection Verification Test
echo ===================================================
echo.
echo Checking Node.js installation...
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed or not in PATH!
    echo Please install Node.js from https://nodejs.org
    pause
    exit /b 1
)

echo [OK] Node.js is available.
echo.
echo Testing MCP Remote bridge to Zepto server (https://mcp.zepto.co.in/mcp)...
echo Press Ctrl+C anytime to terminate test.
echo.
npx -y mcp-remote https://mcp.zepto.co.in/mcp
pause
