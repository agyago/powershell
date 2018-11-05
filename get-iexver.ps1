$array = @()
$keyname = 'SOFTWARE\\Microsoft\\Internet Explorer'
$computernames = Get-Content C:\temp\Computer.csv
foreach ($server in $computernames){
    $reg = [Micosoft.Win32.RegistryKey]::OpenRemoteBasekey('LocalMachine',$server)
    $key = $reg.OpenSubkey($keyname)
    $value = $key.GetValue('Version')
    $obj = New-Object psobject
    $obj | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $server
    $obj | Add-Member -MemberType NoteProperty -Name "IEversion" -Value $value
    $array += $obj
}
$array | Select-Object ComputerName, IEversion | Export-Csv IEversion.csv