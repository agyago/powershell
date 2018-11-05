erroractionpreference = "SilentlyContinue"

$outputDir = "C:\tempsoftwareresults.csv"

#path for lists of computers
Write-Host -ForegroundColor yellow "checking computers which are online"
$arrcomputers = Get-Content -Path "c:\temp\machines.txt" | Where-Object {Test-Connection -ComputerName $_ -quiet -Count 2}

#programs you are looking using % as wildcard

Write-Host
Write-Host "Type the name of Software (%Greyware%)"
$filter = Read-Host "The % sign is the wildcard char"
if (!$filter){
    Write-Host -ForegroundColor red "no filter set"
    Break
}
$(foreach($strcomputer in $arrcomputers){
    get-wmiobject -class win32_product -ComputerName $strcomputer -filter "Name like" $filter |
    Select-Object PScomputerName, Name, Version, InstallDate

    foreach ($objitem in $colitems){
        $objitem.PScomputerName
        $objitem.Name
        $objitem.Version
        $objitem.InstallDate
    }
}) | Export-csv -NoTypeInformation $outputDir
Write-Host
Write-Host -ForegroundColor yellow "script complete"