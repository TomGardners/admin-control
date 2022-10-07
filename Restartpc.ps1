<### tom d

### synopsis
restarts a pc, tells you the uptime and logged in person

### improvements
use the username lookup script to find the name from the clock card

### problems
sometimes doesn't actually come up with the username? no idea why but the script still works

#>


Clear-Host
$PCname = Read-Host "what PC would you like to RESTART" #target of script
$Credential = Get-Credential $PCname\administrator #authentication to get there

function uptime #returns the uptime of the pc
        {
        (Get-Date) - [Management.ManagementDateTimeConverter]::ToDateTime((Get-WmiObject Win32_OperatingSystem -ComputerName $PCName -Credential $Credential -ErrorAction SilentlyContinue).LastBootUpTime)
        }

function chkuptime # checks if uptime is greater or less than 0 min
{
    Start-Sleep -seconds 2
    if ((uptime).Minutes -gt '0')
        {
        clear-host
        write-host "$PCName pending restart"
        uptime | format-list Days,Hours,Minutes
        chkuptime
        }
    if ((uptime).Minutes -lt  '1')
        {
        Clear-Host
        write-host "$PCName has restarted and is ready to go again"
        uptime | format-list Days,Hours,Minutes
        chkuptime
        }
}



Get-WMIObject -ClassName Win32_ComputerSystem -ComputerName "$pcname" -Credential $Credential | Select-Object Username  # tells you whos logged in #  - \\itsyshorse\workshop\Signed\userlookup.ps1?
uptime | format-list Days,Hours,Minutes #current up time
$Ans = Read-Host -Prompt "do you want to restart $PCname y/n" #restart y/n
    If ($Ans -eq 'Y') 
        {
        clear-host
        write-host "attempting to restart"
        restart-computer -Computername $PCname -Credential $Credential -Force
        uptime | format-list Days,Hours,Minutes
        }

try 
    {
    chkuptime
    }
catch 
    {
    clear-host
    write-host "restarting"
    }
finally 
    {
    chkuptime
    }