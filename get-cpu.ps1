Import-module VMware.VimAutomation.Core, VMware.VimAutomation.Vds, VMware.VimAutomation.Cloud, VMware.VimAutomation.Cis.Core, VMware.VimAutomation.HA, VMware.VimAutomation.vROps, VMware.VumAutomation, VMware.DeployAutomation

$result = @()

$vms = Get-View -ViewType VirtualMachine
foreach ($vm in $vms){
    $obj = New-Object psobject
    $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $vm.Name
    $obj | Add-Member -MemberType NoteProperty -Name CPUs -Value $vm.config.hardware.NumCPU
    $obj | Add-Member -MemberType NoteProperty -Name Sockets -Value ($vm.config.hardware.NumCPU/$vm.config.hardware.NumCoresPerSocket)
    $obj | Add-Member -MemberType NoteProperty -Name CPUPerSocket -Value $vm.config.hardware.NumCoresPerSocket
    $obj | Add-Member -MemberType NoteProperty -Name RAM -Value $vm.config.hardware.MemoryMB

    $result += $obj

}

$result| Format-Table | Out-file c:\temp\cpuresult.txt

