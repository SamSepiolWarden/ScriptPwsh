Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All", "UserAuthenticationMethod.ReadWrite.All"

# Loop to change password for 30 accounts
for ($i = 1; $i -le 30; $i++) {
    $email = "aiworkshop$i@sociabble.com"
    
    # Search for user
    $SearchUser = Get-MgUser -UserId $email

    if ($null -eq $SearchUser) {
        Write-Host "User $email not found" -ForegroundColor Red
    }
    else {
        Write-Host "User found for $email" -ForegroundColor Cyan
        
        # Display User Details 
        $SearchUser | Select-Object DisplayName, UserPrincipalName

        # Assuming a predetermined or dynamically generated password
        $newPassword = "Sociabble2024IA!" # Update this line with your password logic if necessary
        $passwordProfile = @{ 
            Password = $newPassword 
            ForceChangePasswordNextSignIn = $false
        } 

        # Update the user password
        Update-MgUser -UserId $email -PasswordProfile $passwordProfile

        if ($?) {
            Write-Host "Password changed successfully for $email" -ForegroundColor Green
        }
        else {
            Write-Host "Error in changing password for $email" -ForegroundColor Red
            Write-Host $Error
        }
    }
}

Write-Host "Completed changing passwords for all users." -ForegroundColor Green
Disconnect-MgGraph
