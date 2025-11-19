#########################################################################################################################################################################
<#
Title   : DNS Debug Logs Disabling
Purpose : To Disable DNS Debug Logs
Output  : It will Disable DNS Debug Logs from All DC Servers
#>
#########################################################################################################################################################################

### Child Script

Set-DnsServerDiagnostics -DebugLogging $false
Limit-EventLog -LogName 'DNS Server' -OverflowAction OverwriteOlder -RetentionDays 7 -MaximumSize 102400KB
Get-DnsServerDiagnostics
Get-EventLog -List | ft
Remove-Item -Path C:\Windows\System32\dns\*.log -Exclude dns2019*
Get-ChildItem -Path C:\Windows\System32\dns