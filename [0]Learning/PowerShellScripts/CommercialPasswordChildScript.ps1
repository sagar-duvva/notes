#########################################################################################################################################################################
<#
Title   : Commercial Password Expiry
Purpose : To generate of password expiry details
Output  : It create system log in every DC with mentioned Event ID
#>
#########################################################################################################################################################################

### Child Script

#$eventId=Read-Host -Prompt "Enter 5 Digit Event Id you want to set e.g. 65432"

$users = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordLastSet -gt 0} -Properties "Name","msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Name",@{Name ="PasswordExpiry"; Expression = {([datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")).tostring("dd-MM-yyyy")}}
foreach($user in $users){
	$Name = $user.Name 
    $ExpiredDate = $user.PasswordExpiry
	$Message = "Passsword is going to expired on $ExpiredDate for $Name user "
	$log = Get-EventLog -List
	Write-EventLog -LogName "System" -source "Service Control Manager" -EntryType Information -EventId "65333" -Message "$Message"
}

### End of the Script
