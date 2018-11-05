Import-module VMware.VimAutomation.Core, VMware.VimAutomation.Vds, VMware.VimAutomation.Cloud, VMware.VimAutomation.Cis.Core, VMware.VimAutomation.HA, VMware.VimAutomation.vROps, VMware.VumAutomation, VMware.DeployAutomation

Connect-VIServer $vshpereserver

function UsedSpace {
    param($ds)
    [math]::Round(($ds.CapacityMB - $ds.FreeSpaceMB)/1024,2)
}
function FreeSpace {
    param ($ds)
    [math]::Round($ds.FreeSpaceMB/1024,2)
}
function PercFree {
    param ($ds)
    [math]::Round((100*$ds.FreeSpaceMB / $ds.CapacityMB),0)
    
}
$Datastores = Get-Datastore
$myCol = @()
Foreach ($Datastore in $Datastores){
    $myObj = "" | Select-Object Datastore, UsedGB, FreeGB, PercFree
    $myObj.Datastore = $Datastore.Name
    $myObj.UsedGB = UsedSpace $Datastore
    $myObj.FreeGB = FreeSpace $Datastore
    $myObj.PercFree = PercFree $Datastore
    $myCol += $myObj
}
$myCol | Sort-Object PercFree | ConvertTo-Html | Out-File $Output
Invoke-Item $Output
