#########################################################################################################################################################################
<#
Title   : Express Patching
Purpose : To Express Patch All VMs in All Subs
Output  : It Express Patch All VMs in All Subs
#>
#########################################################################################################################################################################

### Child Script

$PSWU=Get-InstalledModule | where {$_.Name -match "PSWindowsUpdate"}
if($PSWU -ne $null){}esle{Install-Module -Name PSWindowsUpdate -Confirm:$false -Force}


ipmo PSWindowsUpdate; Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot -ForceInstall -Verbose -Confirm:$false >> C:\Windows\Temp\pswindowsupdate.log
$message = gc C:\Windows\Temp\pswindowsupdate.log | Out-String
Write-EventLog -LogName "System" -source "Service Control Manager" -EntryType Information -EventId "65001" -Message "$Message"
