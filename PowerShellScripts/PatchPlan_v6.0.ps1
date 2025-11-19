#########################################################################################################################################################################
<#
Title   : Patch Plan
Purpose : To Generate Current VMs Data for Monthly Patching
Output  : It will generate and excel sheet with all subscription/workload vms details
#>
#########################################################################################################################################################################

Login-AzAccount

$Report = @()
[String]$Filepath = Read-Host -Prompt "Enter Output File Path like e.g. D:\FolderName" ## Soruce CSV Folder

$Subs = Get-AzSubscription | where {$_.State -Like "Enabled*"}
$Sub_Count = $Subs.Count
Write-Host "Subs count is $Sub_Count " -ForegroundColor Yellow


foreach($Sub in $Subs){           
#####
#####
$ProcessingCount1=$j+1
$RemainingCount1=$Subs.count-$ProcessingCount1
Write-Host "Processing Subscription $ProcessingCount1 | Remaining Subscriptions $RemainingCount1" -ForegroundColor Yellow



$subname = $Sub.Name
$SubscriptionId = $Sub.ID

#####
#####

if($subname -like '*Notes*' -and $subname -notlike '*QA*' -and $subname -notlike '*Test*' ){
Select-AzSubscription -SubscriptionId $SubscriptionId |Out-Null
$VM = Get-AzVM
If($VM.Count -le 0){
$Inactive +=$subname
}else{
$TotalVMCount = $VM.Count
$JBVMCount= $VM | where{$_.Name -like "JB*" -or $_.Name -like "MWS*" -or $_.Name -like "VPN*"}
$LinuxVms = $VM | where {$_.StorageProfile.OsDisk.OsType -like "Linux"}
$Report = New-Object -TypeName PSObject -Property @{
 SubName = $Sub.Name
 SubID   = $Sub.ID 
 Total_VMS = $TotalVMCount
 Ring0_VMS = $JBVMCount.Count
 Linuxvms =$LinuxVms.Count 
 Ring1 = $TotalVMCount-$JBVMCount.Count-$LinuxVms.Count}
$Report | select SubName,SubID,Total_VMS,Ring0_VMS,Linuxvms,Ring1 | Export-Csv "$Filepath\Notes.csv" -Append -NoTypeInformation
}
}

#####
#####

elseif($subname -like "*FileShare*" -and $subname -notlike "*QA*" -and  $subname -notlike '*Test*'){
Select-AzSubscription -SubscriptionId $SubscriptionId |Out-Null
$VM = Get-AzVM
If($VM.Count -le 0){
$Inactive +=$subname
}else{
$TotalVMCount = $VM.Count
$JBVMCount= $VM | where{$_.Name -like "JB*" -or $_.Name -like "MWS*" -or $_.Name -like "VPN*"}
$LinuxVms = $VM | where {$_.StorageProfile.OsDisk.OsType -like "Linux"}
$Report = New-Object -TypeName PSObject -Property @{
                                  SubName = $Sub.Name
                                  SubID   = $Sub.ID 
                                  Total_VMS = $TotalVMCount
                                  Ring0_VMS = $JBVMCount.Count
                                  Linuxvms =$LinuxVms.Count 
                                  Ring2 = $TotalVMCount-$JBVMCount.Count-$LinuxVms.Count
                                  }
$Report | select SubName,SubID,Total_VMS,Ring0_VMS,Linuxvms,Ring2 | Export-Csv "$Filepath\FileShare.csv" -Append -NoTypeInformation
}
}

#####
#####

elseif($subname -like "*Gdrive*" -and $subname -notlike "*QA*" -and $subname -notlike  "*Mover*" -and $subname -notlike '*Test*'){
Select-AzSubscription -SubscriptionId $SubscriptionId |Out-Null
$VM = Get-AzVM
If($VM.Count -le 0){
$Inactive +=$subname
}else{
$TotalVMCount = $VM.Count
$JBVMCount= $VM | where{$_.Name -like "JB*" -or $_.Name -like "MWS*" -or $_.Name -like "VPN*"}
$LinuxVms = $VM | where {$_.StorageProfile.OsDisk.OsType -like "Linux"}
$Report = New-Object -TypeName PSObject -Property @{
                                  SubName = $Sub.Name
                                  SubID   = $Sub.ID 
                                  Total_VMS = $TotalVMCount
                                  Ring0_VMS = $JBVMCount.Count
                                  Linuxvms =$LinuxVms.Count 
                                  Ring2 = $TotalVMCount-$JBVMCount.Count-$LinuxVms.Count}
$Report | select SubName,SubID,Total_VMS,Ring0_VMS,Linuxvms,Ring2 | Export-Csv "$Filepath\Gdrive.csv" -Append -NoTypeInformation
}
}


elseif($subname -like "*Mover*" -and $subname -notlike "*QA*" -and $subname -notlike '*Test*'){
Select-AzSubscription -SubscriptionId $SubscriptionId |Out-Null
$VM = Get-AzVM
If($VM.Count -le 0){
$Inactive +=$subname
}else{
$TotalVMCount = $VM.Count
$JBVMCount= $VM | where{$_.Name -like "JB*" -or $_.Name -like "MWS*" -or $_.Name -like "VPN*"}
$LinuxVms = $VM | where {$_.StorageProfile.OsDisk.OsType -like "Linux"}
$Report = New-Object -TypeName PSObject -Property @{
                                  SubName = $Sub.Name
                                  SubID   = $Sub.ID 
                                  Total_VMS = $TotalVMCount
                                  Ring0_VMS = $JBVMCount.Count
                                  Linuxvms =$LinuxVms.Count 
                                  Ring2 = $TotalVMCount-$JBVMCount.Count-$LinuxVms.Count
                                  }
$Report | select SubName,SubID,Total_VMS,Ring0_VMS,Linuxvms,Ring2 | Export-Csv "$Filepath\Mover.csv" -Append -NoTypeInformation
}
}

#####
#####

elseif($subname -like "*InfraAndSec*" -or $subname -like "*Svemu*" -or $subname -like "*BackEndMigration*" ){
Select-AzSubscription -SubscriptionId $SubscriptionId |Out-Null
$VM = Get-AzVM
If($VM.Count -le 0){
$Inactive +=$subname
}else{
$TotalVMCount = $VM.Count
$JBVMCount= $VM | where{$_.Name -like "JB*" -or $_.Name -like "MWS*" -or $_.Name -like "VPN*"}
$LinuxVms = $VM | where {$_.StorageProfile.OsDisk.OsType -like "Linux"}
$Report = New-Object -TypeName PSObject -Property @{
                                  SubName = $Sub.Name
                                  SubID   = $Sub.ID 
                                  Total_VMS = $TotalVMCount
                                  Ring0_VMS = $JBVMCount.Count
                                  Linuxvms =$LinuxVms.Count 
                                  Ring2 = $TotalVMCount-$JBVMCount.Count-$LinuxVms.Count}
$Report | select SubName,SubID,Total_VMS,Ring0_VMS,Linuxvms,Ring2 | Export-Csv "$Filepath\Productionvms.csv" -Append -NoTypeInformation
}
}

#####
#####

else{
Select-AzSubscription -SubscriptionId $SubscriptionId | Out-Null
$VM = Get-AzVM
If($VM.Count -le 0){
$Inactive +=$subname
}else{
$TotalVMCount = $VM.Count
$JBVMCount= $VM | where{$_.Name -like "JB*" -or $_.Name -like "MWS*" -or $_.Name -like "VPN*"}
$LinuxVms = $VM | where {$_.StorageProfile.OsDisk.OsType -like "Linux"}
$Report = New-Object -TypeName PSObject -Property @{
                                  SubName = $Sub.Name
                                  SubID   = $Sub.ID 
                                  Total_VMS = $TotalVMCount
                                  Ring0_VMS = $JBVMCount.Count
                                  Linuxvms =$LinuxVms.Count 
                                  Ring2 = $TotalVMCount-$JBVMCount.Count-$LinuxVms.Count
                                  }
$Report | select SubName,SubID,Total_VMS,Ring0_VMS,Linuxvms,Ring2 | Export-Csv "$Filepath\Testsub.csv" -Append -NoTypeInformation
}
}
}
############################################################################
$currentMonth = Get-Date -UFormat %m
$currentyear = Get-Date -UFormat %y
$currentMonth = (Get-Culture).DateTimeFormat.GetMonthName($currentMonth)
##############################################################################
Function Merge-CSVFiles{
Param(
$CSVPath = $Filepath, ## Soruce CSV Folder
$XLOutput="$Filepath\pathplan-$currentMonth-$currentyear.xlsx" ## Output file name
)

$csvFiles = Get-ChildItem ("$CSVPath\*") -Include *.csv
$Excel = New-Object -ComObject Excel.Application 
$Excel.visible = $false
$Excel.sheetsInNewWorkbook = $csvFiles.Count
$workbooks = $excel.Workbooks.Add()
$CSVSheet = 1

Foreach ($CSV in $Csvfiles){
$worksheets = $workbooks.worksheets
$CSVFullPath = $CSV.FullName
$SheetName = ($CSV.name -split "\.")[0]
$worksheet = $worksheets.Item($CSVSheet)
$worksheet.Name = $SheetName
$TxtConnector = ("TEXT;" + $CSVFullPath)
$CellRef = $worksheet.Range("A1")
$Connector = $worksheet.QueryTables.add($TxtConnector,$CellRef)
$worksheet.QueryTables.item($Connector.name).TextFileCommaDelimiter = $True
$worksheet.QueryTables.item($Connector.name).TextFileParseType  = 1
$worksheet.QueryTables.item($Connector.name).Refresh()
$worksheet.QueryTables.item($Connector.name).delete()
$worksheet.UsedRange.EntireColumn.AutoFit()
$CSVSheet++

}

$workbooks.SaveAs($XLOutput,51)
$workbooks.Saved = $true
$workbooks.Close()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbooks) | Out-Null
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

}


Merge-CSVFiles -CSVPath "$Filepath" -XLOutput "$Filepath\pathplan-$currentMonth-$currentyear.xlsx"

$Date=Get-Date
Write-Host "Script Execution Complete $Date" -ForegroundColor Yellow
### End of the Script