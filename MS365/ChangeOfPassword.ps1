Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All", "UserAuthenticationMethod.ReadWrite.All"

# Start a loop
$AskAnotherUser = "Y"

while ($AskAnotherUser -eq "Y") {
    
# Prompt User
$UserPass = Read-Host -Prompt "Enter the UPN"

# Search for user
$SearchUSer = Get-MgUser -UserId $UserPass | Select-Object DisplayName

if ($null -eq $SearchUSer) {
    Write-Host "User not found" -ForegroundColor Red | break
    $AskAnotherUser = Read-Host -Prompt "Do you want to change another user? (Y/N)"

}
else {
    Write-Host "User found for $SearchUser" -ForegroundColor Cyan
    
    # Display User Details 
    $SearchUSer | Select-Object DisplayName, UserPrincipalName
}
$AskPass = Read-Host -Prompt "Do you want to Change $SearchUser Password? (Y/N)"
if ($AskPass -eq "Y") {
    $PasswordChange = Read-Host -Prompt "Enter the new Password"
    $password = @{ 
        Password = $PasswordChange 
        ForceChangePasswordNextSignIn= $false
        } 
        Update-MgUser -UserId $UserPass -PasswordProfile $password
        if ($?) {
Write-Host "Password changed successfully for $SearchUser" -ForegroundColor Green
Write-Host "Password is $PasswordChange" -ForegroundColor Cyan
        }
        else {
Write-Host "Error in the change of password"  -ForegroundColor Red
            Write-Host $Error
        }
        $AskAnotherUser = Read-Host -Prompt "Do you want to change another user? (Y/N)"
}
}
if ($AskPass -eq "N") {
Write-Host "End of change of password" | Disconnect-MgGraph
}