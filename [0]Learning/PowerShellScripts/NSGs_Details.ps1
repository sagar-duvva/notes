#########################################################################################################################################################################
<#
Title   : NSG Rules Details
Purpose : To get NSG Rules Details from all Subs
Output  : It will generate an excel sheet with all subscription/workload NSG Rules Details
#>
#########################################################################################################################################################################



[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"
Write-Host "Selected OutPut Path $OutputPath" -ForegroundColor Yellow


### Connects to Azure
Connect-AzAccount

### Collects all Subs details
$Subs = Get-AzSubscription | ? {$_.State -like "Enabled"} | Select -ExpandProperty Id

$count = $Subs.count
foreach($Sub in $Subs)
{
 
Write-Host $count "Subscriptions are pending"
$SubscriptionId = $Sub.ID
Write-Host "Script executing on" $Sub.Name
Select-AzSubscription -Subscription $SubscriptionId |Out-Null
$Sub_Context_Name=(Get-AzContext).Subscription | Select -ExpandProperty Name
$Sub_Context_Id=(Get-AzContext).Subscription | Select -ExpandProperty Id
$RGs = Get-AzResourceGroup
$rgcount = $RGs.count
 
        if($rgcount -ge 1){
        
        $NSGs = Get-AzNetworkSecurityGroup
        
        foreach($NSG in $NSGs) 
        {
        $NSGName=$NSG.Name
        $NSGRG=$NSG.ResourceGroupName

        $NSGRules = Get-AzNetworkSecurityGroup -Name $NSGName -ResourceGroupName $NSGRG | Get-AzNetworkSecurityRuleConfig
        $data1 = $NSGRules | select Protocol,Name,Access,Priority,Direction,ProvisioningState
        $data1 | Add-Member -Type NoteProperty -Name CustomerName -Value $Sub_Context_Name
        $data1 | Add-Member -Type NoteProperty -Name CustomerId -Value $Sub_Context_Id
        $data1 | Add-Member -Type NoteProperty -Name NSGName  -Value $NSGName
        $data1 | select CustomerName,CustomerId,NSGName,Protocol,Name,Access,Priority,Direction,ProvisioningState | Export-Csv -Path "$OutputPath\NSGsDetails.csv" -Append -NoTypeInformation
        }

        }
        else{Write-Host "No Resource Groups are available in Sub $Sub_Context_Name and its Id is $Sub_Context_Id" -ForegroundColor Red}

    $count = $count-1;
    $RGs = $null;
    $NSGs = $null;
    $NSGs = $null
    $NSGRules = $null;
    $data1 = $null;
    
 }


$Date=Get-Date
Write-Host "Script Execution Complete $Date" -ForegroundColor Yellow
### End of the Script
 