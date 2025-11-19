#########################################################################################################################################################################
<#
Title   : Enabled Subs with Zero VMs
Purpose : To get Enabled Subs with Zero VMs
Output  : It will generate an excel sheet with Enabled Subs with Zero VMs
#>
#########################################################################################################################################################################



Connect-AzAccount

[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"
Write-Host "Selected OutPut Path $OutputPath" -ForegroundColor Yellow

$Sub_Id = Get-AzSubscription | ? {$_.State -like "Enabled"} | Select -ExpandProperty Id
$Sub_Count = $Sub_Id.Count
Write-Host "Subs count is $Sub_Count " -ForegroundColor Yellow


for($j=0 ; $j -lt $Sub_Id.count ; $j++)
{
$ProcessingCount1=$j+1
$RemainingCount1=$Sub_Id.count-$ProcessingCount1
Write-Host "Processing Subscription $ProcessingCount1 | Remaining Subscriptions $RemainingCount1" -ForegroundColor Yellow
$Select_Sub=Select-AzSubscription $Sub_Id[$j]
###
$Sub_Context_Name=(Get-AzContext).Subscription | Select -ExpandProperty Name
$Sub_Context_Id=(Get-AzContext).Subscription | Select -ExpandProperty Id
###
$VM_Details=Get-AzVM -Status
$VM_Count=$VM_Details.Count

#####

if($VM_Count -eq "0"){

$combinedResults=@()
for($i=0;$i -le $VM_Count ; $i++){
$tabName = "Power State Info"
$table = New-Object system.Data.DataTable “$tabName”
$col1 = New-Object system.Data.DataColumn Subscription_Name,([string])
$col2 = New-Object system.Data.DataColumn Subscription_Id,([string])
$col3 = New-Object system.Data.DataColumn VM_Count,([string])
$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)
$row = $table.NewRow()
$row.Subscription_Name = $Sub_Context_Name
$row.Subscription_Id = $Sub_Context_Id
$row.VM_Count = $VM_Count[$i]
$table.Rows.Add($row)
$combinedResults += $table
}

}
Else{ Write-Host " $Sub_Context_Name is having $VM_Count VMs." -ForegroundColor Red }

##
$combinedResults | Export-CSV -Append -NoTypeInformation -Path $OutputPath\AllSubswith0VMs.csv
}