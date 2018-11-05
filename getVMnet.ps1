&{foreach($vm in (get-vm)){
    $vm.extentiondata.guest.net | Select-Object -property @{N='VM';E={$vm.Name}},
    @{N='Host';E={$vm.VMHost.Name}},
    @{N='OS';E={$vm.Guest.OSFullName}},
    @{N='NicType';E={[string]::Join(',',(Get-NetworkAdapter -VM $vm | Select-Object -expandProperty Type))}}
}
}| Export-Csv c:\temp\report.csv
