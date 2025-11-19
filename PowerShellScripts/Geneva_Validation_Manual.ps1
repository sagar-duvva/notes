[String]$OutputPath="D:\Geneva"     #### Output Location

Start-Transcript -path "$OutputPath\Geneva_Transcript.txt" -append

Select-AzSubscription -Subscription "319f17b8-2255-4600-8b38-9dbcf2547085" | Out-Null   ##### Subscription ID
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
 


