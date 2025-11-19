#########################################################################################################################################################################
<#
Title   : All VMs along with VMSize & OS Details
Purpose : To get all VMs Details from all Subs
Output  : It will generate an excel sheet with all subscription/workload VMs Details
#>
#########################################################################################################################################################################



Login-AzAccount

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

if($VM_Count -gt "0"){

$VM_Name=$VM_Details | Select -ExpandProperty Name
$VM_Size=$VM_Details.HardwareProfile.VmSize
$VM_OSType=$VM_Details.StorageProfile.OsDisk.OsType
$VM_OSSku=$VM_Details.StorageProfile.ImageReference.Sku
$VM_OSOffer=$VM_Details.StorageProfile.ImageReference.Offer


$combinedResults=@()
for($i=0;$i -lt $VM_Name.count ; $i++)
{
$tabName = "Power State Info"
$table = New-Object system.Data.DataTable “$tabName”
$col1 = New-Object system.Data.DataColumn Subscription_Name,([string])
$col2 = New-Object system.Data.DataColumn Subscription_Id,([string])
$col3 = New-Object system.Data.DataColumn VM_Name,([string])
$col4 = New-Object system.Data.DataColumn VM_Size,([string])
$col5 = New-Object system.Data.DataColumn VM_OSType,([string])
$col6 = New-Object system.Data.DataColumn VM_OSSku,([string])
$col7 = New-Object system.Data.DataColumn VM_OSOffer,([string])
$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)
$table.columns.add($col4)
$table.columns.add($col5)
$table.columns.add($col6)
$table.columns.add($col7)
$row = $table.NewRow()
$row.Subscription_Name = $Sub_Context_Name
$row.Subscription_Id = $Sub_Context_Id
$row.VM_Name = $VM_Name[$i]
$row.VM_Size = $VM_Size[$i]
$row.VM_OSType = $VM_OSType[$i]
$row.VM_OSSku = $VM_OSSku[$i]
$row.VM_OSOffer = $VM_OSOffer[$i]
$table.Rows.Add($row)
$combinedResults += $table
}

##
$combinedResults | Export-CSV -Append -NoTypeInformation -Path $OutputPath\AllSubsVMswithOS.csv
}
Else{ Write-Host " $Sub_Context_Name is having $VM_Count VMs." -ForegroundColor Red }
}
