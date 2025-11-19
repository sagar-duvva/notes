#########################################################################################################################################################################
<#
Title   : Disabled Subs
Purpose : To Get Disabled Subs
Output  : It will generate an excel sheet with all Disabled Subs Details
#>
#########################################################################################################################################################################


[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"
Write-Host "Selected OutPut Path $OutputPath" -ForegroundColor Yellow

Connect-AzAccount
$DeSubs = Get-AzSubscription | ? {$_.State -like "Disabled"}
$DeSubs | Select Name, SubscriptionId, State | Export-Csv -Append -NoTypeInformation -Path $OutputPath\DisabledSubs.csv  

$Date=Get-Date
Write-Host "Script Execution Complete $Date" -ForegroundColor Yellow
### End of the Script