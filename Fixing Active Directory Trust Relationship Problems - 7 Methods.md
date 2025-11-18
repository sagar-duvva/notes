Fixing Active Directory Trust Relationship Problems: 7 Methods  
  
Encountered trust relationship issues in Active Directory? Here are 6 methods to resolve them:  
  
Method 1: Disjoin & Rejoin Domain  
1. Disjoin: djoin /leave  
2. Reboot  
3. Rejoin: djoin /domain <DomainName> /user <DomainAdminUser> /password:*  
4. Reboot again  
  
Method 2: PowerShell Repair  
5. Test-ComputerSecureChannel -Repair -Credential <DomainName>\Administrator  
6. Reboot  
  
Method 3: Reset Computer Password (PowerShell)  
7. Reset-ComputerMachinePassword -Server <DomainServer> -Credential <DomainName>\Administrator  
8. Restart  
  
Method 4: Netdom Reset  
9. netdom resetpwd /Server:<DomainController> /UserD:<DomainAdmin> /PasswordD:*  
10. Restart  
  
Method 5: Delete & Recreate Computer Object  
11. Delete computer object from ADUC  
12. Remove-Computer -UnjoinDomainCredential <DomainName>\Administrator  
13. Restart and rejoin: Add-Computer -DomainName "<DomainName>" -Credential <DomainName>\Administrator -Restart  
  
Method 6: Time Sync  
14. w32tm /resync  
15. Manually set time sync if needed: w32tm /config /manualpeerlist:"(link unavailable)" /syncfromflags:manual /update  
  
Method 7: Disconnect Network Cabel  
If its urgent and you want to fix it in few seconds then just remove network cable and login and connect network cabel  
These methods can help resolve trust relationship issues in Active Directory. Try them out and see what works best for you.  
  
Active Directory, Trust Relationship, IT, Windows Server, PowerShell.