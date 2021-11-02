# Storyline: Using the Get-Process and Get-service
#Get-Process | Select-Object ProcessName, Path, ID | Export-Csv -Path "C:\Users\champuser\Desktop\myProcesses.csv" -NoTypeInformation
#Get-Process | Get-Memember
Get-Service | where { $_.Status -eq "Stopped" } | Export-Csv -Path "C:\Users\champuser\Desktop\myRunningServices.xlsx" -NoTypeInformation
#Get-Process | where { $_.Status -eq "Stopped" }
# Export-Csv -Path "C:\Users\champuser\Desktop\myRunningProcesses.csv" -NoTypeInformation