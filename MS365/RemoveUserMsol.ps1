Connect-MsolService

# Prompt the user you need to delete
$User = Read-Host -Prompt "Enter the user principal name of the user to delete"

# Get the user
$UserToDelete = Get-MsolUser -UserPrincipalName $User

# Delete the user
Remove-MsolUser -UserPrincipalName $User -Force

# Check if the user is deleted
$UserToDelete = Get-MsolUser -UserPrincipalName $User
if ($null -eq $UserToDelete) {
    Write-Host "User deleted successfully"
}
else {
    Write-Host "User not deleted"
}

