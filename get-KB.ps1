$hotfix = read-host "hotfix? "
Get-Content c:\temp\computers.txt | Where-Object {$_ -AND (Test-Connection $_ -Quiet)} |
ForEach-Object {
    Get-Hotfix $hotfix -computername $_ | Select-Object CSname, Description, HotfixID, InstalledOn
}

