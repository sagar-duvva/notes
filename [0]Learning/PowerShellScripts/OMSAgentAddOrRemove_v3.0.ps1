 #########################################################################################################################################################################
<#
Title   : OMS Agent Extension Adding or Removal
Purpose : To Add or Remove OMS Agent Extension.
Output  : Based on Selected Options It will Either Add or Remove OMS Extension from provided vms.
#>
#########################################################################################################################################################################



Login-AzAccount
$subID = Read-Host -Prompt "Subscription ID:"
Select-AzSubscription -Subscription $subID | Out-Null
$failedvms = Read-Host -Prompt "Provide Failed VMs list in CSV file formate"
$VMObjects = Import-Csv $failedvms
$allvms = Get-AzVM -Status
$AffectedVM  = @()

foreach($item in $VMObjects){
    $AffectedVM += $allvms |? {$_.Name -match $item.Name} | select Name,ResourceGroupName,Powerstate,Location
}

Write-Host "To Remove oms Extension Select 1" -ForegroundColor Red
Write-Host "To Add OMS extension Select 2" -ForegroundColor Green
$choice = Read-Host "Select your Option"

[int]$Test=Read-Host "To Remove OMS extension select '1' or To Add OMS extension Select '2', Please select your option by typing it here:"


if($choice -eq 1){ 

workflow removeoms{
    param ([psobject]$AffectedVMs)

    foreach -parallel -throttlelimit 5 ($VM in $AffectedVMs){  
Remove-AzVMExtension -ResourceGroupName $($VM.ResourceGroupName) -VMName $($VM.Name) -Name "Microsoft.EnterpriseCloud.Monitoring" -confirm:$false -Force         
    }
}
Select-AzSubscription -Subscription $subID | Out-Null
removeoms -AffectedVMs $AffectedVM

}Elseif($choice -eq 2){

workflow addoms{
    param ([psobject]$AffectedVMs)
     
    foreach -parallel -throttlelimit 5 ($VM in $AffectedVMs){  
Set-AzVMExtension -ResourceGroupName $($VM.ResourceGroupName) -VMName $($VM.Name) -Name 'Microsoft.EnterpriseCloud.Monitoring' -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType 'MicrosoftMonitoringAgent' -TypeHandlerVersion '1.0' -Location $($VM.Location) -SettingString "{'workspaceId': '2a6981d8-1296-442a-901d-d95e9c25439f'}" -ProtectedSettingString "{'workspaceKey': 'OW9DDDeLsnM/ZdC9ntZsGMwz+di5DVmD4y0F4X6klT/zYSM6ib3jVFAMfAHXjJTgdEnZ64f9UTLnyQLp5w2cFQ=='}"  
    }
}
Select-AzSubscription -Subscription $subID | Out-Null
addoms -AffectedVMs $AffectedVM
}
Else{Write-Host "Typed wrong/Unknown keyword '$choice', please re-run the script and use '1' or '2' Keyword" -ForegroundColor Red}


$Date=Get-Date
Write-Host "Script Execution Complete $Date" -ForegroundColor Yellow
### End of the Script
