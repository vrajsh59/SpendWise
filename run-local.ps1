# Starts SpendWise locally: MongoDB (existing service) + Express API + Vite dev server.
# Usage: right-click -> Run with PowerShell, or:  powershell -ExecutionPolicy Bypass -File .\run-local.ps1

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$backend = Join-Path $root "backend"
$frontend = Join-Path $root "frontend\spendwise"

# 1. Make sure the local MongoDB service is running
$mongo = Get-Service -Name "MongoDB" -ErrorAction SilentlyContinue
if ($mongo -and $mongo.Status -ne "Running") {
    Start-Service -Name "MongoDB"
}

# 2. Backend API on http://localhost:5000
Start-Process powershell -ArgumentList @(
    "-NoExit", "-Command",
    "Set-Location '$backend'; Write-Host 'Starting SpendWise API...' -ForegroundColor Cyan; node server.js"
)

# 3. Frontend on http://localhost:5173
Start-Process powershell -ArgumentList @(
    "-NoExit", "-Command",
    "Set-Location '$frontend'; Write-Host 'Starting SpendWise UI...' -ForegroundColor Cyan; npm run dev"
)

Start-Sleep -Seconds 4
Write-Host ""
Write-Host "SpendWise is starting:" -ForegroundColor Green
Write-Host "  UI  -> http://localhost:5173"
Write-Host "  API -> http://localhost:5000/healthz"
