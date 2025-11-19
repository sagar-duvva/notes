#########################################################################################################################################################################
<#
Title   : IAM Details of User
Purpose : To get Selected User IAM Details from all Subs
Output  : It will generate an excel sheet with Single User IAM Details
#>
#########################################################################################################################################################################


[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"
Write-Host "Selected OutPut Path $OutputPath" -ForegroundColor Yellow

[String]$UserSearch=Read-Host -Prompt "Enter user email id to search for e.g. v-user@microsoft.com"
Write-Host "Selected user email id $UserSearch" -ForegroundColor Yellow


Login-AzAccount
$Sub=Get-AzSubscription | where {$_.State -eq "Enabled"} | Select -ExpandProperty Id


### looper ###
for($i=0; $i -lt $Sub.count; $i++){
$ProcessingCount=$i+1
$RemainingCount=$Sub.count-$ProcessingCount
Write-Host "Processing Subscription $ProcessingCount | Remaining Subscriptions $RemainingCount" -ForegroundColor Cyan
$Select_Sub=Select-AzSubscription -Subscription $Sub[$i] | Select -ExpandProperty Name
$Sub_Context_Name=(Get-AzContext).Subscription | Select -ExpandProperty Name
$Sub_Context_Id=(Get-AzContext).Subscription | Select -ExpandProperty Id

### Code ###
$check_access=Get-AzRoleAssignment -IncludeClassicAdministrators | Where-Object {$_.SignInName -like $UserSearch} | select DisplayName, SignInName, ObjectId, RoleDefinitionName, Scope

###
$DisplayName=$check_access.DisplayName
$SignInName=$check_access.SignInName
$User_ObjectId=$check_access.ObjectId
$Role=$check_access.RoleDefinitionName
$Scope=$check_access.Scope

###
$combinedResults=@()
for($j=0;$j -lt $DisplayName.count ; $j++)
{
$tabName = "IAM"
$table = New-Object system.Data.DataTable “$tabName”
$col1 = New-Object system.Data.DataColumn Subscription_Name,([string])
$col2 = New-Object system.Data.DataColumn Subscription_Id,([string])
$col3 = New-Object system.Data.DataColumn DisplayName,([string])
$col4 = New-Object system.Data.DataColumn SignInName,([string])
$col5 = New-Object system.Data.DataColumn User_ObjectId,([string])
$col6 = New-Object system.Data.DataColumn RoleDefinitionName,([string])
$col7 = New-Object system.Data.DataColumn Scope,([string])
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
$row.DisplayName = $DisplayName[$j]
$row.SignInName = $SignInName[$j]
$row.User_ObjectId = $User_ObjectId[$j]
$row.RoleDefinitionName = $Role[$j]
$row.Scope = $Scope[$j]
$table.Rows.Add($row)
$combinedResults += $table
}

###
$combinedResults | Export-CSV -Append -NoTypeInformation -NoClobber -Path "$OutputPath\IAM.csv"

}
$Date=Get-Date
Write-Host "Script Execution Complete $Date" -ForegroundColor Yellow
### End of the Parent Script