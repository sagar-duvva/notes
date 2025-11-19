$pwdSS = ConvertTo-SecureString -String 'P@ssw0rd!@#’ -AsPlainText -Force
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Verbose

Import-Module ADDSDeployment

Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "testdom.local" `
-DomainNetbiosName "TESTDOM" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-SafeModeAdministratorPassword $pwdSS `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
