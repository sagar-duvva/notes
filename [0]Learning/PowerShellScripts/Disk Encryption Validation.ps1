#########################################################################################################################################################################
<#
Title   : Azure VM Disk Encryption Validation
Purpose : To Get Details of Azure VM Disk Encryption
Output  : It will generate an excel sheet with Details of Azure VM Disk Encryption
#>
#########################################################################################################################################################################



Connect-AzAccount

[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"
Write-Host "Selected OutPut Path $OutputPath" -ForegroundColor Yellow


$Sub_Id = Get-AzSubscription | ? {$_.State -like "Enabled"} | Select -ExpandProperty Id
$Sub_Count = $Sub_Id.Count
Write-Host "Subs count is $Sub_Count " -ForegroundColor Yellow


Select-AzSubscription -Subscription $Sub_Id

$VMS=Get-AzVm -Status
$VMS2=$VMS
$RG= $VMS | Select -ExpandProperty ResourceGroupName
$VM_Name= $VMS | Select -ExpandProperty Name
$Date=Get-Date

Write-Host "Disk Encryption Validation Started on $Date"  -ForegroundColor Yellow


$combinedResults_Disk=@()
for ($vmc=0;$vmc -lt $VM_Name.Count ;$vmc++){

$Get_Encryption_Status=Get-AzVMDiskEncryptionStatus -VMName $VM_Name[$vmc] -ResourceGroupName $RG[$vmc]
$OsVolumeEncrypted= $Get_Encryption_Status| Select -ExpandProperty OsVolumeEncrypted
$DataVolumesEncrypted= $Get_Encryption_Status| Select -ExpandProperty DataVolumesEncrypted

$tabName1_Disk = "Disk Encryption Settings"
$table1_Disk = New-Object system.Data.DataTable "$tabName1_Disk"
$col1_Disk = New-Object system.Data.DataColumn VM_Name,([string])
$col2_Disk = New-Object system.Data.DataColumn OsVolumeEncrypted,([string])
$col3_Disk = New-Object system.Data.DataColumn DataVolumesEncrypted,([string])


$table1_Disk.columns.add($col1_Disk)
$table1_Disk.columns.add($col2_Disk)
$table1_Disk.columns.add($col3_Disk)

$current_vm_disk=$VM_Name[$vmc]

$row_Disk = $table1_Disk.NewRow()
$row_Disk.VM_Name = $current_vm_disk
$row_Disk.OsVolumeEncrypted = $OsVolumeEncrypted
$row_Disk.DataVolumesEncrypted = $DataVolumesEncrypted

$table1_Disk.Rows.Add($row_Disk)
$combinedResults_Disk += $table1_Disk
 
}


$combinedResults_Disk | Export-Csv -path "$OutputPath\DiskEncryptionValidation.csv" -Append -NoTypeInformation


$Date=Get-Date
Write-Host "Disk Encryption Validation Completed on $Date"  -ForegroundColor Yellow