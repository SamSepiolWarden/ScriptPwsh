Connect-SPOService -Url https://sociabble-admin.sharepoint.com
$User = Read-Host -Prompt "Enter the email to remove from site"
Remove-SPOUser -Group "Sociabble - Membres" -LoginName $User -Site "https://sociabble.sharepoint.com/sites/sociabble"
if($?)
{Write-Host Succesfully remove -ForegroundColor Green}
else
{Write-Host -ErrorAction Stop -ForegroundColor Red}
Disconnect-SPOService