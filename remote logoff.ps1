<#
 Author
 Tomdav
 
 # remotely logs off a user on your network #
 changes: 
 - needs to display all the current users and choose which one to log off
 - confirmation that the user has logged off
 #>
 
 $Name=read-Host "PC name"
$Cred=Get-Credential $Name\administrator

$win32OS = get-wmiobject win32_operatingsystem -computername $Name -Credential $Cred -EnableAllPrivileges
$win32OS.win32shutdown(4)
