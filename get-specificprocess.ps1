$hostname = read-host "server: "
$process = read-host "process: "
Get-wmiobject -Class win32_process -ComputerName $hostname |
Where-Object {$_.processname -like $process} |
sort-object -Property ws -Descending |
Select-Object @{Name = 'Server';E={[String]$_.csname}}, processname,@{Name='Mem Usage(GB)';E={[math]::Truncate($_.ws /1gb)}},
@{Name='VM Size(GB)';E={[math]::truncate($_.vm /1gb)}},@{Name='processid';E={[string]$_.processid}},@{Name='userid';E={$_.getowner().user}} |
Format-Table -AutoSize | Out-String -Width 4000 | Write-Output