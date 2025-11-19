#########################################################################################################################################################################
<#
Title   : All VMs along with VMSize Details
Purpose : To get all VMs Details from all Subs
Output  : It will generate an excel sheet with all subscription/workload VMs Details
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

if($VM_Count -gt "0"){

$VM_Name=$VM_Details | Select -ExpandProperty Name
$VM_Location=$VM_Details | Select -ExpandProperty Location
$VM_Size=$VM_Details.HardwareProfile.VmSize
$PowerStateInfo=$VM_Details | Select -ExpandProperty PowerState

$combinedResults=@()
for($i=0;$i -lt $VM_Name.count ; $i++)
{
$tabName = "Power State Info"
$table = New-Object system.Data.DataTable “$tabName”
$col1 = New-Object system.Data.DataColumn Subscription_Name,([string])
$col2 = New-Object system.Data.DataColumn Subscription_Id,([string])
$col3 = New-Object system.Data.DataColumn VM_Name,([string])
$col4 = New-Object system.Data.DataColumn VM_Location,([string])
$col5 = New-Object system.Data.DataColumn VMSize,([string])
$col6 = New-Object system.Data.DataColumn PowerState,([string])
$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)
$table.columns.add($col4)
$table.columns.add($col5)
$table.columns.add($col6)
$row = $table.NewRow()
$row.Subscription_Name = $Sub_Context_Name
$row.Subscription_Id = $Sub_Context_Id
$row.VM_Name = $VM_Name[$i]
$row.VM_Location = $VM_Location[$i]
$row.VMSize = $VM_Size[$i]
$row.PowerState = $PowerStateInfo[$i]
$table.Rows.Add($row)
$combinedResults += $table
}

##
$combinedResults | Export-CSV -Append -NoTypeInformation -Path $OutputPath\AllSubsVMswithSize.csv

}Else{ Write-Host " Sub_Context_Name is having $VM_Count VMs." -ForegroundColor Red }

}
