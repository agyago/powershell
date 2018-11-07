Connect-VIServer $newserver
Connect-VIServer $oldserver
#$location is the path where your servers are
#$nic is the current nic
#$migratenic is for the new nic
$report=@()
$VMservers=Get-Content $location
foreach ($VM in $VMservers){
    $oldnic = $nic
    $newnic = $migratenic
    $vhost = Get-Cluster $clustername | Get-VMHost
    Invoke-VMScript -VM $VM { ipconfig >> c:\temp\ip.txt}
    Get-VM $VM | Shutdown-VMGuest -Confirm:$false
    Start-Sleep -Seconds 60
    $file = get-vm $VM | get-view | ForEach-Object {$_.config.files.vmpathname}
    $vmranhost = Get-Random -InputObject $vhost
    Remove-VM -VM $VM -Confirm:$false
    New-VM -VMFilePath "$file" -VMHost $vmranhost
    Get-VM $VM | Get-NetworkAdapter | Where-Object {$_.NetworkName -eq $oldnic} | Set-NetworkAdapter -NetworkName $newnic -Confirm:$false -ErrorAction SilentlyContinue
    Set-VM $VM -Version v11 -Confirm:$false
    try{
        Start-VM -VM $VM -Confirm:$false -ErrorAction Stop -ErrorVariable errstop
    }
    catch [VMware.VimAutomation.ViCore.Types.V1.ErrorHandling.VmBlockedByQuestionException]{
        Get-VMQuestion -VM $VM | Set-VMQuestion -DefaultOption -Confirm:$false
    }
    Start-Sleep -Seconds 120
    Update-Tools -VM $VM -ErrorAction SilentlyContinue -RunAsync
    Start-Sleep -Seconds 120
    Write-Host -ForegroundColor green $VM "located at" $vmranhost

    if ((get-vm $VM).ExtensionData.config.hardware.device.backing.ThinProvisioned -eq $true){
        Get-VM $VM | Move-VM -Datastore $datamigration -DiskStorageFormat Thick -Confirm:$false -ErrorAction SilentlyContinue -ErrorVariable miglog -RunAsync
        Start-Sleep -Seconds 120
    }
    foreach($virtual in Get-View -ViewType virtualmachine -Filter @{'Name'= "$VM"}){
        $vms = "" | Select-Object Hostname, VMhost, ToolsVer, NICType, HWver, Datastore, DiskStorageFormat
        $vms.Hostname = $virtual.guest.Hostname
        $vms.VMhost = Get-View -id $virtual.Runtime.host -Property Name | Select-Object -ExpandProperty Name
        $vms.ToolsVer = $virtual.config.tools.toolsversion
        $vms.NICType = get-vm -name $virtual.Name | Get-NetworkAdapter | Select-Object -ExpandProperty type
        $vms.HWver = $virtual.config.version
        $vms.Datastore = $virtual.config.Datastoreurl[0].Name
        $vms.DiskStorageFormat = get-vm -Name $virtual.name | Get-HardDisk | Select-Object -ExpandProperty storageformat
        $report += $vms
    }
}$report | Format-Table -AutoSize


