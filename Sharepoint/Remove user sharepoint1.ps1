Connect-SPOService
$UserAccount = Read-Host -Prompt "Enter the mail adress"
$SitesCollections = Get-SPOSite -Limit ALL
ForEach($Site in $SitesCollections)
{
    Write-Host -f Yellow "Checking Site Collection:"$Site.URL
    $User = Get-SPOUser -Limit All -Site $Site.URL | Where {$_.LoginName -eq $UserAccount}
    Remove-SPOUser -Site $Site.URL -LoginName $UserAccount

 If($?)
       {
        Write-Host "$User Succesfully Removed" -ForegroundColor Green
       }
Else
       {
        Write-Host $User -ErrorAction Stop -ForegroundColor Red
       }
 }
 Disconnect-SPOService