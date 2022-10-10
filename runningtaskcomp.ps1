<### tom d

## helps compare what task you just closed if it crashed 

## improve
#if current run time is closer or passed the next run time then highlight it

## problems

display currently running tasks
shows all the cancelled tasks last run
saves the names of them 


#>
$taskCRun = get-ScheduledTask | Where-Object State -eq running
$taskInfo = Get-ScheduledTask | get-scheduledtaskinfo | select-object TaskName,TaskPath,LastRunTime,LastTaskResult,NextRunTime

Compare-Object -ReferenceObject ($taskCRun).TaskName -DifferenceObject ($taskInfo).TaskName -ExcludeDifferent