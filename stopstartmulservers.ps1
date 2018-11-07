
##stop service
Get-Content "c:\temp\servers.txt" | ForEach-Object {set-service -computername $_ -name $service -status stopped}


##start-service
Get-Content "c:\temp\servers.txt" | ForEach-Object {set-service -computername $_ -name $service -status running}