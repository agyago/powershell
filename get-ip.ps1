#Extract IP NIC settings and place it on C:\temp
#works with set-nicip.ps1

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
$nic = get-wmiobject -class win32_networkadapterconfiguration -filter ipenabled=true
$iptable = @()
foreach ($n in $nic){
    $parent = "" | Select-Object IPadd, DGW, Subnet, dns
    $parent.IPadd= ($n.IPAddress[0])
    $parent.DGW=($n.DefaultIPGateway -join ';')
    $parent.subnet = $n.IPsubnet[0]
    $parent.dns = ($n.DNSServerSearchOrder -join ';')
    $iptable += $parent
}
$iptable | Export-Csv c:\temp\iptemp.csv