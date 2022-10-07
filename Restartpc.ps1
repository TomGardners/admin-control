<### tom d

### synopsis
restarts a pc, tells you the uptime and logged in person

### improvements
use the username lookup script to find the name from the clock card

i want it to have a count function for when it's restarting, this is a maybe code?
function counter
{
    $counter = 0
    for ($counter -lt 20)
    {
        Start-sleep 0
        $Counter++
        write-host $Counter
        if ($Counter -eq 10)
        {
            Start-sleep 5
        }
        If ($Counter -eq 20)
        {
            write-host "it's taking a while, maybe it's broken :("
        }
    }
}

### problems
sometimes doesn't actually come up with the username? no idea why but the script still works on standard domain joined pc's

#>


function testpc #check if the PC is online already, if not will say it's offline and ask again
{
    $PCname = read-Host -prompt "PC hostname to restart: " #asks for hostname
    if (Test-Connection -ComputerName $PCname -Quiet -Count 1) #pings it
        {
        $Credential = Get-Credential $PCname\administrator #auth


        function uptime #returns the uptime of the pc
                {
                (Get-Date) - [Management.ManagementDateTimeConverter]::ToDateTime((Get-WmiObject Win32_OperatingSystem -ComputerName $PCName -Credential $Credential -ErrorAction SilentlyContinue).LastBootUpTime)
                }

        function chkuptime # checks if uptime is greater or less than 0 min
        {
            Start-Sleep -seconds 2 #updates status every 2 seconds
            if ((uptime).Minutes -gt '0') #if the uptime is more than 0 mins
                {
                clear-host
                write-host "$PCName pending restart"
                uptime | format-list Days,Hours,Minutes #shows uptime
                chkuptime # runs the check again
                }
            if ((uptime).Minutes -lt '1') #if uptime is less than 1 min
                {
                Clear-Host
                write-host "$PCName has restarted and is ready to go again"
                uptime | format-list Days,Hours,Minutes #shows uptime
                chkuptime # runs the check again
                }
        }


        Get-WMIObject -ClassName Win32_ComputerSystem -ComputerName "$pcname" -Credential $Credential | Select-Object Username  # tells you whos logged in #  - \\itsyshorse\workshop\Signed\userlookup.ps1?
        uptime | format-list Days,Hours,Minutes #current up time
        $Ans = Read-Host -Prompt "do you want to restart $PCname y/n" #restart y/n
            If ($Ans -eq 'y') 
                {
                clear-host
                write-host "attempting to restart"
                restart-computer -Computername $PCname -Credential $Credential -Force # restart PC force
                uptime | format-list Days,Hours,Minutes #shows uptime
                }
            if ($Ans -ne 'y' ) #if 'n' on answer, it will just exit
                {Exit}

        try 
            {
            chkuptime # if uptime errors (due to restarting/rpc not available)
            }
        catch 
            {
            clear-host 
            write-host "currently restarting :)" #handles the error and makes it pretty
            }
        finally 
            {
            chkuptime # re-runs the check to see if it's sorted
            }


        }
else #if the pc was offline when typing in hostname
    {
    write-host "$PCname is offline"
    }
testpc # asks for the hostname again
}

testpc # runs the whole script