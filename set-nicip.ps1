#import ip from get-ip.ps1

$server = Import-Csv c:\temp\iptemp.csv
$servernic = get-wmiobject win32_networkadapterconfiguration -filter ipenabled=true
$servernic.enablestatic($server.Ipadd, $server.subnet)
$servernic.SetGateways($server.DGW)
$servernic.SetDNSServerSearchOrder($server.dns)
ipconfig /all