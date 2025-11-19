[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"

Start-Transcript -path "$OutputPath\Geneva_Transcript.txt" -append

Connect-AzAccount
$Sub_Id = Get-AzSubscription | ? {$_.State -like "Enabled"} | Select -ExpandProperty Id
$Sub_Count = $Sub_Id.Count
Write-Host "Subs count is $Sub_Count " -ForegroundColor Yellow



for($j=0 ; $j -lt $Sub_Id.count ; $j++)
{
$ProcessingCount1=$j+1
$RemainingCount1=$Sub_Id.count-$ProcessingCount1
Write-Host "Processing Subscription $ProcessingCount1 | Remaining Subscriptions $RemainingCount1" -ForegroundColor Yellow
$Select_Sub=Select-AzSubscription $Sub_Id[$j]
Start-Job -Name $Sub_Id[$j] -ScriptBlock {
$Sub_Context_Name=(Get-AzContext).Subscription | Select -ExpandProperty Name
$Sub_Context_Id=(Get-AzContext).Subscription | Select -ExpandProperty Id


###


###

$VM_Details=Get-AzVM -Status
#$VM_Name=$VM_Details | Select -ExpandProperty Name
#$RG=$VM_Details | Select -ExpandProperty ResourceGroupName
$VMN=$VM_Details.Name
$VMRG=$VM_Details.ResourceGroupName
$VMPS=$VM_Details.PowerState


$combinedResults=@()
for($i=0; $i -lt $VM_Details.count ; $i++)
{
#
$ProcessingCount2=$i+1
$RemainingCount2=$VM_Details.count-$ProcessingCount2
Write-Host "Processing VM $ProcessingCount2 | Remaining VMs $RemainingCount2" -ForegroundColor Cyan

$ProvisioningState= 1..$VM_Name.count | foreach { $false }

# Extension Status
$ProvisioningState=Get-AzVMExtension -ResourceGroupName $VMRG[$i] -VMName $VMN[$i] -Name 'GenevaMonitoring' -ErrorAction SilentlyContinue| Select -ExpandProperty 'ProvisioningState' 


$tabName = "Geneva Validation Results"
$table = New-Object system.Data.DataTable “$tabName”
$col1 = New-Object system.Data.DataColumn Subscription_Name,([string])
$col2 = New-Object system.Data.DataColumn Subscription_Id,([string])
$col3 = New-Object system.Data.DataColumn VM_Name,([string])
$col4 = New-Object system.Data.DataColumn PowerState,([string])
$col5 = New-Object system.Data.DataColumn ProvisioningState ,([string])
$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)
$table.columns.add($col4)
$table.columns.add($col5)
$row = $table.NewRow()
$row.Subscription_Name = $Sub_Context_Name
$row.Subscription_Id = $Sub_Context_Id
$row.VM_Name = $VMN[$i]
$row.PowerState = $VMPS[$i]
$row.ProvisioningState = $ProvisioningState
$table.Rows.Add($row)
$combinedResults += $table
}



$combinedResults | Export-CSV -Append -NoTypeInformation -Path "$OutputPath\Geneva_Validation.csv"

}  | Format-List -Property InstanceId,Id,Name,ChildJobs,PSBeginTime,State  
} 

$Date=Get-Date
Write-Host "Execution Complete $Date"  -ForegroundColor Yellow

Stop-Transcript

