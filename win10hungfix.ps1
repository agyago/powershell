#connect to vcenter
Write-Host -ForegroundColor green "enter vcnter hostname"
$vcenter = Read-Host
Write-Host -ForegroundColor cyan "connecting...."
Connect-VIServer $vcenter

$vmv = Get-VMHost $hosts | get-vm | Get-View
$name = $vmv.name
$guestid = $vmv.summary.config.guestFullName
$vmx = New-Object VMware.Vim.VirtualMachineConfigSpec
$vmx.ExtraConfig += New-Object VMware.Vim.OptionValue
$vmx.ExtraConfig[0].key = "monitor_control.enable_softResetClearTSC"
$vmx.ExtraConfig[0].value = "TRUE"

foreach ($vm in $vmv){
    $vmversion = get-vm $vm.name | Select-Object Version
    $vmadv = get-vm $vm.name | Get-AdvancedSetting
    if ($vm.summary.config.guestFullName -eq "Microsoft Windows 8 (64-bit)" -and $vmversion.version -eq "v10" -and $vmvadv.name -contains "monitor_control.enable_softResetClearTSC"){
        Write-Host -ForegroundColor red $vm.name "already has the fix applied"
    }
    Elseif($vm.summary.config.guestFullName -eq "Microsoft Windows 8 (64-bit)" -and $vmversion.version -eq "v10" -and $vmvadv.name -notcontains "monitor_control.enable_softResetClearTSC"){
        ($vm).ReconfigVM_Task($vmx)
        Write-Host -ForegroundColor yellow "applied fox to" $vm.name
    }

}