$GenMonAgSet=New-ScheduledTaskSettingsSet -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1) -StartWhenAvailable
$GenMonAgSet.ExecutionTimeLimit = 'PT0S'
Set-ScheduledTask "GenevaMonitoringAgent" -Settings $GenMonAgSet
$GenMonAg=Get-ScheduledTask "GenevaMonitoringAgent"
$GenMonAg.Settings