Connect-MsolService
$UserPrincipalName = Read-Host -Prompt "Enter the account to remove "
Remove-MsolUser -UserPrincipalName "$UserPrincipalName" -Force