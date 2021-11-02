# Storyline: Use commands to start and stop the calculator application

#help Start-Process -Examples
Start-Process -FilePath "win32calc"

#help Stop-Process -Examples
timeout /t 2

Stop-Process -Name "win32calc"

