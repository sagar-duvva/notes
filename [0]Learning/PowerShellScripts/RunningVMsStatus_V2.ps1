#########################################################################################################################################################################
<#
Title   : Running VMs Status
Purpose : To get Running VMs Status
Output  : It will generate an excel sheet with Running VMs Status Details
#>
#########################################################################################################################################################################




Login-AzAccount
[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"
$outputdata = @()
[String]$workload = Read-host -Prompt "SubScritption Type Ex:Gdrive,Box,FileShare,MoverIO,Notes:"
$Subs = Get-AzSubscription | ? {$_.State -like "Enabled"} | ? {$_.Name -like "*" +$workload + "*"}


foreach($Sub in $Subs)
{


                  $SubscriptionId = $Sub.ID
                  Select-AzSubscription -SubscriptionId $SubscriptionId | Out-Null
                  $Sub_Context_Name=(Get-AzContext).Subscription | Select -ExpandProperty Name

                  Write-Host "Currently Working on $Sub_Context_Name" -ForegroundColor Yellow

                  $VM = Get-AzVM -status -WarningAction Ignore
 
                  $data = $VM |select "ResourceGroupName","Name","PowerState"
                  $data | Add-Member -Type NoteProperty -Name CustomerName  -Value $sub.Name
            #########################################################################################
                 $running = 0;
                 $powerdoff = 0;
                 $others = 0;
                 $inactive = 0
                 if($VM.Count -le 0)
                 {
                 $inactive++;
                 }
                 else
                 {
                  foreach($VMS in $VM)
                  {
   

                   if($VMS.PowerState -contains "VM running")
                       {
                        $running++
        
                       }
                    else
                    {
                         if($VMS.PowerState -contains "VM deallocated")

                         {
                          $powerdoff++
                         }

                         else
                         {
                          $others++;
                         }
                    }
   
                  }


                  $Report = New-Object -TypeName PSObject -Property @{
                                CustomerName = $sub.Name 
                                Total_VMS = $VM.count
                                Running_VMS = $running
                                Poweredoff_VMS = $powerdoff
                                OtherStateof_VMs = $others
                                }

           
                            $outputdata +=  $Report

  
                  }


  
                }


$outputdata | select CustomerName,Total_VMS,Running_VMS, Poweredoff_VMS,OtherStateof_VMs | Export-Csv -Path $OutputPath\RunningVMsState.csv -Append

$Date=Get-Date
Write-Host "Script Execution Complete $Date" -ForegroundColor Yellow
### End of the Script
