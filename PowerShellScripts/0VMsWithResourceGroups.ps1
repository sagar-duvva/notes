#########################################################################################################################################################################
<#
Title   : Resources Groups with Zero VMs
Purpose : To get Resource Groups with Zero VMs
Output  : It will generate an excel sheet with Resource Groups with Zero VMs
#>
#########################################################################################################################################################################



Connect-AzAccount

[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"
Write-Host "Selected OutPut Path $OutputPath" -ForegroundColor Yellow

$Sub_Id = Get-AzSubscription | ? {$_.State -like "Enabled"} | Select -ExpandProperty Id
$Sub_Count = $Sub_Id.Count
Write-Host "Subs count is $Sub_Count " -ForegroundColor Yellow


for($j=0 ; $j -lt $Sub_Id.Count ; $j++)
{
$ProcessingCount1=$j+1
$RemainingCount1=$Sub_Id.Count-$ProcessingCount1
Write-Host "Processing Subscription $ProcessingCount1 | Remaining Subscriptions $RemainingCount1" -ForegroundColor Yellow
$Select_Sub=Select-AzSubscription $Sub_Id[$j]
###
Start-Job -Name $Sub_Id[$j] -ScriptBlock {
$Sub_Context_Name=(Get-AzContext).Subscription | Select -ExpandProperty Name
$Sub_Context_Id=(Get-AzContext).Subscription | Select -ExpandProperty Id
###
$VM_Details=Get-AzVM -Status
$VM_Count=$VM_Details.Count

###

if($VM_Count -eq 0){


$RG=Get-AzResourceGroup
$RG_Count=$RG.Count

if($RG_Count -ne 0){
$Resource=Get-AzResource

$Resource_RGName=$Resource | select -ExpandProperty ResourceGroupName
$Resource_Name=$Resource | select -ExpandProperty Name
$Resource_Type=$Resource  | select -ExpandProperty ResourceType
$Resource_Location=$Resource  | select -ExpandProperty Location
$Resource_ID=$Resource  | select -ExpandProperty ResourceId


#####
$combinedResults=@()
for($i=0;$i -lt $Resource.count ; $i++){
$tabName = "Resources"
$table = New-Object system.Data.DataTable “$tabName”
$col1 = New-Object system.Data.DataColumn Subscription_Name,([string])
$col2 = New-Object system.Data.DataColumn Subscription_Id,([string])
$col3 = New-Object system.Data.DataColumn Resource_RGName,([string])
$col4 = New-Object system.Data.DataColumn Resource_Name,([string])
$col5 = New-Object system.Data.DataColumn Resource_Type,([string])
$col6 = New-Object system.Data.DataColumn Resource_Location,([string])
$col7 = New-Object system.Data.DataColumn Resource_ID,([string])
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
$row.Resource_RGName = $Resource_RGName[$i]
$row.Resource_Name = $Resource_Name[$i]
$row.Resource_Type = $Resource_Type[$i]
$row.Resource_Location = $Resource_Location[$i]
$row.Resource_ID = $Resource_ID[$i]
$table.Rows.Add($row)
$combinedResults += $table
}
}else{Write-Host " $Sub_Context_Name is having $RG_Count RGs." -ForegroundColor Red}
}else{Write-Host " $Sub_Context_Name is having $VM_Count VMs." -ForegroundColor Red}
##
$combinedResults | Export-CSV -Append -NoTypeInformation -Path $OutputPath\ResourcesNew.csv
}  | Format-List -Property InstanceId,Id,Name,ChildJobs,PSBeginTime,State  #Start Job loop
} #$j loop
