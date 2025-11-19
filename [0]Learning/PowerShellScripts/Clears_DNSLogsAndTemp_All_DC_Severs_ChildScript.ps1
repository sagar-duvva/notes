#########################################################################################################################################################################
<#
Title   : Temp Files & DNS Logs Deletion
Purpose : To Clear Temp Files and DNS Logs from All DC Servers
Output  : It will Clear Temp Files and DNS Logs from All DC Servers
#>
#########################################################################################################################################################################

### Child Script

$TempFileLocation = "$env:windir\Temp","$env:TEMP"
$DNSLogs = "$env:windir\System32\dns"


$TempFile = Get-ChildItem $TempFileLocation -Recurse
$TempFile | Remove-Item -Confirm:$false -Recurse -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue



$DNSLogs = Get-ChildItem $DNSLogs -Recurse
$DNSLogs | Remove-Item -Confirm:$false -Recurse -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue


