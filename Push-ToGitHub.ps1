# One-click push to GitHub
# Right-click -> "Run with PowerShell"
# Repo: https://github.com/fhyyyyyy/Fhy.git

# Force UTF-8 output
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$ErrorActionPreference = "Stop"
$projectDir = $PSScriptRoot
Set-Location $projectDir

function OK   { param($m) Write-Host "[OK] $m" -ForegroundColor Green }
function STEP { param($n, $m) Write-Host "" ; Write-Host "[$n/5] $m" -ForegroundColor Yellow }
function ERR  { param($m) Write-Host "[ERR] $m" -ForegroundColor Red }
function INFO { param($m) Write-Host "      $m" -ForegroundColor Gray }

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " IELTS Vocab App - One-Click Push to GitHub" -ForegroundColor Cyan
Write-Host " Repo: https://github.com/fhyyyyyy/Fhy.git" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# [1/5] Check Git
STEP 1 "Checking Git..."
try {
    $gitVer = git --version
    OK "Git installed: $gitVer"
} catch {
    ERR "Git not installed!"
    Write-Host "Please install from: https://git-scm.com/download/win" -ForegroundColor Yellow
    pause
    exit 1
}

# [2/5] Init repo
STEP 2 "Initializing Git repository..."
if (-not (Test-Path ".git")) {
    git init | Out-Null
    git branch -M main
    OK "Initialized main branch"
} else {
    OK "Repository already exists"
}

# [3/5] Configure user
STEP 3 "Configuring Git user info..."
$userName = git config user.name
$userEmail = git config user.email
if (-not $userName) {
    $name = Read-Host "Enter your name (for commits)"
    git config user.name $name
    OK "Set user.name = $name"
} else {
    INFO "user.name = $userName"
}
if (-not $userEmail) {
    $email = Read-Host "Enter your email"
    git config user.email $email
    OK "Set user.email = $email"
} else {
    INFO "user.email = $userEmail"
}

# [4/5] Add and commit
STEP 4 "Adding and committing files..."
git remote remove origin 2>$null
git remote add origin https://github.com/fhyyyyyy/Fhy.git
INFO "Remote set to: https://github.com/fhyyyyyy/Fhy.git"

INFO "Adding files..."
git add . | Out-Null
$stagedCount = (git diff --cached --name-only | Measure-Object).Count
INFO "Staged $stagedCount files"

if ($stagedCount -eq 0) {
    INFO "Nothing to commit (already committed)"
} else {
    INFO "First 10 files:"
    git diff --cached --name-only | Select-Object -First 10 | ForEach-Object {
        INFO "  $_"
    }
    $commitMsg = "init: IELTS vocab app - Flutter + Isar + SM-2 + wrong book"
    git commit -m $commitMsg
    OK "Committed: $commitMsg"
}

# [5/5] Push
STEP 5 "Pushing to GitHub..."
INFO "First push will require GitHub login"
INFO "If browser doesn't pop up, manually open https://github.com to login first"
Write-Host ""

try {
    git push -u origin main --force 2>&1 | ForEach-Object { Write-Host $_ }
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host " Push successful!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Open https://github.com/fhyyyyyy/Fhy/actions" -ForegroundColor White
    Write-Host "  2. Wait 10-15 min (yellow dot -> green check)" -ForegroundColor White
    Write-Host "  3. Click green job, scroll to bottom" -ForegroundColor White
    Write-Host "  4. Download ielts-app-debug-apk.zip" -ForegroundColor White
    Write-Host "  5. Unzip -> app-debug.apk -> install on phone" -ForegroundColor White
    Write-Host ""
    Write-Host "Troubleshooting: see GITHUB_ACTIONS_GUIDE.md" -ForegroundColor Yellow
} catch {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host " Push failed" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Possible causes:" -ForegroundColor Yellow
    Write-Host "  1. Browser did not pop up -> manually login to https://github.com" -ForegroundColor White
    Write-Host "  2. Network issue -> retry or use VPN" -ForegroundColor White
    Write-Host "  3. Repo not found -> verify https://github.com/fhyyyyyy/Fhy" -ForegroundColor White
}
Write-Host ""
pause
