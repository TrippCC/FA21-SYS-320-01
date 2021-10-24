#Storyline: Review the Security Event log

#Directory to save files:

$myDir = "C:\Users\champuser"

#List all the avavilable Windows Event Logs
Get-Eventlog -list

# Create a prompt to allow user to select the log to view
$readLog = Read-host -Prompt "Please select a log to review from the list above"

# Print the results for the log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*new process has been*" }
#| export-csv -NoTypeInformation -Path $myDir\SecurityLogs.csv

# CHALLENGE:
# Task: Create prompt that allows the user to specify a keyword of phrase to search on
# Find a string from your even logs to search on 

# Prompt to ask for search string
$searchString = Read-host -Prompt "Please select search string to filter the logs"

# Print the results of the logs using the string as a filter
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*$searchString*" }