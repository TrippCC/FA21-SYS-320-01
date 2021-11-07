# Storyline: View the event logs, check for a valid log, and print the results
<#
function select_log() {
    
    cls

    #List all event logs
    $theLogs = Get-Eventlog -list | select Log
    $theLogs | out-Host

    # Initialize the array to store the logs
    $arrLog = @()

    foreach ($tempLog in $theLogs) {
        
        # Add each log to the array
        # NOTE: these are stored in the array as a hashtable in the format
        # @{Log=LOGNAME}
        $arrLog += $tempLog

    }
    
    #test to be sure the array is working
    #$arrlog

    # Prompt the user for the log they want to view or quit
    $readLog = read-host -Prompt "Please enter a log from the list above or 'q' to quit the program."

    # Check if the user want to quit.
    if ($readLog -match "^[qQ]$") {

        # Stop executing
        break

    }

    log_check -logToSearch $readLog

} # ends the select_log()

function log_check() {

    #String the user types in within the select_log function
    Param([string]$logToSearch)
    #Format the user input
    # Example: @{Log=Security}
    $theLog = "^@{Log=" + $logToSearch + "}$"

    # Search the array for the exact hashtable string
    if ($arrLog -match $theLog) {

        write-host -BackgroundColor Green -ForegroundColor White "Please wait, it may take a few moments to retrieve the log entries."
        sleep 2

        #Call the function to view the log
        view_log -logToSearch $logToSearch

    } else {

        write-host -BackgroundColor Red -ForegroundColor White "The log specified doesn't exist."
        sleep 2
        select_log
    }

} # ends the log_check()



function view_log() {
    
    cls

    #Get the logs
    Get-EventLog -Log $logToSearch -Newest 10 -After "1/18/2020"

    #Pause the screen and wait until the user is ready to proceed.
    Read-Host -Prompt "Press enter when you are done"

    #Go back to select_log
    select_log

} # ends the view_log()

#Run the select_log as the first function
select_log
#>






# Storyline: View the services, check for a valid service status, and print the results

function select_log() {
    
    cls

    #List all event logs
    #$theLogs = Get-Service 
    #$theLogs | out-Host

    # Initialize the array to store the logs
    $arrLog = @("All","Running", "Stopped")

    # Prompt the user for the log they want to view or quit
    $readLog = read-host -Prompt "Please enter a valid Serivce status (All, Running, Stopped) or press 'q' to quit"

    # Check if the user want to quit.
    if ($readLog -match "^[qQ]$") {

        # Stop executing
        break

    }

    log_check -logToSearch $readLog

} # ends the select_log()

function log_check() {

    #String the user types in within the select_log function
    Param([string]$logToSearch)
    #Format the user input
    # Example: @{Log=Security}
    $theLog = "$logToSearch"

    Write-Host $theLog
    # Search the array for the exact hashtable string
    if ($arrLog[0] -match $theLog) {
        
        write-host -BackgroundColor Green -ForegroundColor White "Please wait, it may take a few moments to retrieve the log entries."
        sleep 2

        Get-Service
        

        #Pause the screen and wait until the user is ready to proceed.
        Read-Host -Prompt "Press enter when you are done"

        #Go back to select_log
        select_log

    } elseif ($arrLog[1] -match $theLog) {
        
        write-host -BackgroundColor Green -ForegroundColor White "Please wait, it may take a few moments to retrieve the log entries."
        sleep 2
        
        Get-Service | Where-Object {$_.Status -eq "Running"}
        #Pause the screen and wait until the user is ready to proceed.
        Read-Host -Prompt "Press enter when you are done"

        #Go back to select_log
        select_log

    } elseif ($arrLog[2] -match $theLog) {
        
        write-host -BackgroundColor Green -ForegroundColor White "Please wait, it may take a few moments to retrieve the log entries."
        sleep 2
        
        Get-Service | Where-Object {$_.Status -eq "Stopped"}
        #Pause the screen and wait until the user is ready to proceed.
        Read-Host -Prompt "Press enter when you are done"

        #Go back to select_log
        select_log

    } else {

        write-host -BackgroundColor Red -ForegroundColor White "The status specified doesn't exist."
        sleep 2
        select_log
    }

} # ends the log_check()
select_log


#Not sure why but when prompted to give a valid service status, if you just press 'enter' it acts the same way as if you typed 'All'
