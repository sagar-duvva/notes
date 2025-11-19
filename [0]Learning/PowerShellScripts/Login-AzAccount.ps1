Login-AzAccount

$Sub_Id=Get-AzSubscription | Select-Object -ExpandProperty Id
#$Sub_Id = Read-Host "Please Enter the Subscription Name or ID"

for($j=0 ; $j -lt $Sub_Id.count ; $j++) {
$ProcessingCount1=$j+1
$RemainingCount1=$Sub_Id.count-$ProcessingCount1
Write-Host "Processing Subscription $ProcessingCount1 | Remaining Subscriptions $RemainingCount1" -ForegroundColor Yellow
$Select_Sub=Select-AzSubscription $Sub_Id[$j]
$Sub_Context_Name=(Get-AzContext).Subscription | Select-Object -ExpandProperty Name
$Sub_Context_Id=(Get-AzContext).Subscription | Select-Object -ExpandProperty Id
Start-Transcript -Path .\$Sub_Context_Name.txt -Append -Verbose -Force


<# 
#Start-Job -Name $Sub_Id[$j] -ScriptBlock {

#$sub = Read-Host "Please Enter the Subscription Name or ID"
#Select-AzSubscription -Subscription $sub
#$Sub_Context_Name=(Get-AzContext).Subscription | Select-Object -ExpandProperty Name
#>

$AllAzRG = Get-AzResourceGroup
foreach ($RG in $AllAzRG)

    $rgname=$RG.ResourceGroupName
    #$Resources = Get-AzResource -ResourceGroupName $rgname # | Where-Object {$_.ResourceType -inotmatch "Microsoft.Compute/virtualMachines/extensions" -and $_.ResourceType -inotmatch "Microsoft.RecoveryServices" -and $_.ResourceType -inotmatch "Microsoft.KeyVault/vaults"}
    $RGLock = Get-AzResourceLock -ResourceGroupName $rgname #-ResourceName $rname -ResourceType $rtype
        <#ForEach($Resource in $Resources){
            $rname=$Resource.Name
            $rtype=$Resource.Type
            Write-Host "Checking the Resource lock status on Resources $rname"  -ForegroundColor Yellow
            $RGLock = Get-AzResourceLock -ResourceGroupName $rgname -ResourceName $rname -ResourceType $rtype
        }#>
    

$combinedResults=@()
for($i=0;$i -lt $VM_Name.count ; $i++){
$tabName = "Power State Info"
$table = New-Object system.Data.DataTable “$tabName”
$col1 = New-Object system.Data.DataColumn Subscription_Name,([string])
$col2 = New-Object system.Data.DataColumn Subscription_Id,([string])
$col3 = New-Object system.Data.DataColumn ResourceGroupName,([string])
$col4 = New-Object system.Data.DataColumn RGLock,([string])
$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)
$table.columns.add($col4)
$row = $table.NewRow()
$row.Subscription_Name = $Sub_Context_Name
$row.Subscription_Id = $Sub_Context_Id
$row.VM_Name = $RG[$i]
$row.PowerState = $RGLock[$i]
$table.Rows.Add($row)
$combinedResults += $table
}


} 

$combinedResults | Export-CSV -Append -NoTypeInformation -Path ".\ResourceLockStatus.csv"

Write-Host "";
Write-Host "********** Completed Choosen Operation **********"; 
Write-Host ""
Stop-Transcript