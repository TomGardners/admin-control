<#
author: tomdav
# removes provisioned apps from windows with a nice GUI #
changes:

#>

Add-Type -AssemblyName System.Windows.Forms
$form=New-Object System.Windows.Forms.Form
$form.StartPosition='CenterScreen'
$form.Size='600,800'


$okButton = New-Object System.Windows.Forms.Button
$form.Controls.Add($okButton)
$okButton.Dock = 'Bottom'
$okButton.Height = 50
$okButton.Font = New-Object System.Drawing.Font("Times New Roman", 18, [System.Drawing.FontStyle]::Bold)
$okButton.Text = 'SHRIMP GANG!!!'
$okButton.DialogResult = 'Ok'

$checkedlistbox=New-Object System.Windows.Forms.CheckedListBox
$form.Controls.Add($checkedlistbox)
$checkedlistbox.Dock='Fill'
$checkedlistbox.CheckOnClick=$true

$items=Get-AppxProvisionedPackage -Online | Select PackageName
$checkedlistbox.DataSource=[collections.arraylist]$items
$checkedlistbox.DisplayMember='Caption'

$form.ShowDialog()

# removes checked items
$checkedlistbox.checkeditems | Remove-AppxProvisionedPackage -Online
