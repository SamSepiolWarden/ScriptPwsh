Connect-SPOService -Url https://sociabble-admin.sharepoint.com
$User = Read-Host -Prompt "Enter the email to remove from site"
$Site = Read-Host -Prompt "Enter the name site the user need to be remove"
$Group = Read-Host -Prompt "Enter the group name"
Remove-SPOUser -Group $Group -LoginName $User -Site $Site
if($?)
{Write-Host Succesfully remove -ForegroundColor Green}
else
{Write-Host -ErrorAction Stop -ForegroundColor Red}
Disconnect-SPOService