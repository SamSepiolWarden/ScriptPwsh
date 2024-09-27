Connect-SPOService -Url https://sociabble-admin.sharepoint.com
$User = Read-Host -Prompt "Enter the email to add"
$Site = Read-Host -Prompt "Enter the name site the user need"
$Group = Read-Host -Prompt "Enter the group name"
Add-SPOUser -Group $Group -LoginName $User -Site $Site