#########################################################################################################################################################################
<#
Title   : SKU Change
Purpose : To Change VMs SKU
Output  : It will Change VMs SKU
#>
#########################################################################################################################################################################


Login-AzAccount
[String]$Sub=Read-Host -Prompt "Enter Subscription ID: "
[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"
[String]$NewSKUs = Read-Host -Prompt "Enter New SKU Size like e.g. Standard_B2s"
[String]$VMNamefile=Read-Host "Please Enter text file path which contains VMs Names e.g D:\CompName.txt"



Select-AzSubscription -Subscription $Sub | Out-Null

$Sub_Context_Name=(Get-AzContext).Subscription | Select -ExpandProperty Name
$Sub_Context_Id=(Get-AzContext).Subscription | Select -ExpandProperty Id

Write-Host "select sub $Sub_Context_Name" -ForegroundColor Yellow
### VMs

$VMnames=gc $VMNamefile
$VM_Count=$vmnames.count
Write-Host "Select VMs"
$VM_Count
$VMnames


$AllVMs = Get-AzVm 
$AllVMs | Write-Output > $OutputPath\$Sub_Context_Name-Old.csv
foreach ($VMs in $VMnames){
$AzVM = $AllVMs | where {$_.Name -contains $VMs}
$VMname = $AzVM.Name
$VMRG = $AzVM.ResourceGroupName

Write-Host "Working on $VMname" -ForegroundColor Yellow

$vm = Get-AzVM -ResourceGroupName $VMRG -Name $VMname
$vm.HardwareProfile.VmSize = $NewSKUs
Update-AzVM -VM $vm -ResourceGroupName $VMRG
Write-Host "Changed SKUs of $VMname to $NewSKUs" -ForegroundColor Magenta
}
$NewVMs = Get-AzVM
$NewVMs | Write-Output > $OutputPath\$Sub_Context_Name-New.csv

### End of the Script ###