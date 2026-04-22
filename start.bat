@echo off
title Supply Chain Anti-Counterfeiting - Startup

echo ============================================
echo  Supply Chain Anti-Counterfeiting Prototype
echo ============================================
echo.
echo Starting local blockchain node...
echo.

:: Open a new window for the Hardhat node and keep it running
start "Hardhat Node" cmd /k "cd /d %~dp0 && npx hardhat node"

:: Wait a few seconds for the node to boot before deploying
echo Waiting for blockchain node to start...
timeout /t 5 /nobreak > nul

echo Deploying smart contract...
call npx hardhat ignition deploy ignition/modules/Lock.ts --network localhost

echo.
echo Starting local web server...
echo.

:: Open a new window for the web server
start "Web Server" cmd /k "cd /d %~dp0 && npx serve ."

echo.
echo ============================================
echo  All systems running!
echo.
echo  Open your browser and go to:
echo  http://localhost:3000
echo.
echo  MetaMask setup reminder:
echo  - Network:  Hardhat Local
echo  - RPC URL:  http://127.0.0.1:8545
echo  - Chain ID: 31337
echo.
echo  You can close this window.
echo ============================================
echo.
pause
