$server=Read-host 'server: '
Get-WmiObject -Class win32_operatingsystem -Namespace "root\cimv2" -ComputerName $server | select @{Name='LastBoot';E={$_.converttodatetime($_.lastbootuptime)}}