Connect-MgGraph

#Import CSv
$users = Import-Csv -Path C:\test\users.csv

#Loop
foreach ($user in $users) {
    $email = $user.UserPrincipalName
    $FirstName = $user.$FirstName
    $LastName = $user.$LastName
    $PasswordPrefix = $FirstName.Substring(0, 2)
    $PaswwordPrefix1 = $LastName.Substring(0, 2)
    $newPassword = "Sociabble2024$PasswordPrefix$PaswwordPrefix1!"
    $passwordProfile = @{ 
        Password = $newPassword 
        ForceChangePasswordNextSignIn = $false
    } 
    Update-MgUser -UserId $email -PasswordProfile $passwordProfile
    if($?) {
        Write-Host "Password changed successfully for $email" -ForegroundColor Green
    }
    else {
        Write-Host "Error in changing password for $email" -ForegroundColor Red
    }
}