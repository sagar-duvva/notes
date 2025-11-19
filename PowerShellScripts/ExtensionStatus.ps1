#########################################################################################################################################################################
<#
Title   : VM Extension Status
Purpose : To check VMs Extension Status for all the subscriptions
Output  : It will generate an excel sheet with all subscription/workload VMs Extension Status details
#>
#########################################################################################################################################################################

 
 
[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"
Write-Host "Selected OutPut Path $OutputPath" -ForegroundColor Yellow

[String]$extension=Read-Host -Prompt "Enter Extension Name to generate status e.g. MGM.CustomExtension"
Write-Host "Selected Extension Name $extension" -ForegroundColor Yellow


Start-Transcript -path "$OutputPath\ExtStatus_Transcript.txt" -append

Login-AzAccount

$Sub_Ids = Get-AzSubscription | ? {$_.State -like "Enabled"} | Select -ExpandProperty Id

$outfile1 = @();
$outfile2 = @();

foreach($Sub_Id in $Sub_Ids)
{
Select-AzSubscription -SubscriptionId $Sub_Id | Out-Null
$Sub_Context_Name=(Get-AzContext).Subscription | Select -ExpandProperty Name

$VMs = Get-AzVM -Status

foreach($VM in $VMs){
$extensiondetails = Get-AzVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName | select -ExpandProperty Extensions | select Publisher, VirtualMachineExtensionType, Name, ProvisioningState
if($extensiondetails.Name -match $extension){
$outfile1 = $extensiondetails | where {$_.Name -match $extension} 
$outfile1 | Add-Member -Type NoteProperty -Name SubscriptionName -Value $Sub_Context_Name
$outfile1 | Add-Member -Type NoteProperty -Name VMName -Value $VM.Name
$outfile1 | select SubscriptionName,VMName,Name,ProvisioningState | Export-Csv $OutputPath\ExtensionStatus.csv -NoTypeInformation -Append
}else{
$ExtStatus = "No Agent Found"
$outfile2 | Add-Member -Type NoteProperty -Name SubscriptionName -Value $Sub_Context_Name
$outfile2 | Add-Member -Type NoteProperty -Name VMName -Value $VM.Name
$outfile2 | Add-Member -Type NoteProperty -Name Name -Value $extension
$outfile2 | Add-Member -Type NoteProperty -Name ProvisioningState -Value $ExtStatus
$outfile2 | select SubscriptionName,VMName,Name,ProvisioningState | Export-Csv $OutputPath\ExtensionStatus.csv -NoTypeInformatio -Append
}
}
}
$Date=Get-Date
Write-Host "Script Execution Complete $Date" -ForegroundColor Yellow
Stop-Transcript
### End of the Script