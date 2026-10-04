<#
.SYNOPSIS
    Tests the connection between local environment and the Zepto Remote MCP Server.
.DESCRIPTION
    Verifies Node.js and npx availability, and runs mcp-remote against https://mcp.zepto.co.in/mcp.
#>

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "  Zepto MCP Server - PowerShell Connection Check  " -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

# Check Node.js
try {
    $nodeVersion = node -v
    Write-Host "[OK] Node.js is installed ($nodeVersion)" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Node.js is not found on PATH. Please install Node.js from https://nodejs.org" -ForegroundColor Red
    exit 1
}

# Check npx
try {
    $npxVersion = npx -v
    Write-Host "[OK] npx is installed ($npxVersion)" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] npx is not found on PATH." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Connecting to remote Zepto MCP Server (https://mcp.zepto.co.in/mcp)..." -ForegroundColor Yellow
Write-Host "Press Ctrl+C to terminate test at any time." -ForegroundColor Gray
Write-Host ""

& npx -y mcp-remote https://mcp.zepto.co.in/mcp
