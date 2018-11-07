$DS = Get-Datastore | Where-Object {$_.Name -match $datastores} | 
Select-Object -Property Name, FreeSpaceGB, @{N="percentFreespace";E={[math]::Round(($_.FreeSpaceGB)/($_.CapacityGB)*100,1)}}
$paramet = "30"
$largestdatastore = $null
foreach ($DS in $DS){
    if ($DS.percentFreespace -gt $paramet){
        $largestfreespace = $DS.percentFreespace | Sort-Object -Descending
        $largestdatastore = $DS.name
    }
}
write-host $largestdatastore ' is the largest with '$largestfreespace ' percent freespace'