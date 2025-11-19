#########################################################################################################################################################################
<#
Title   : NTFS Backward Compatibility
Purpose : To fix NTFS Backward Compatibility vulnerability
Output  : It will fix NTFS Backward Compatibility vulnerability
#>
#########################################################################################################################################################################

### Child Script

Invoke-Command -ScriptBlock {Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name NtfsDisable8dot3NameCreation -Value 1 -Verbose -Force -Confirm:$false} -Verbose >> C:\ntfsresult.log