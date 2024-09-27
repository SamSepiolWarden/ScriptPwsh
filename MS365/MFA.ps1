Connect-MsolService
$mf = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
$mf.RelyingParty = "*"
$mfa = @($mf)
$UserPrincipalName = Read-Host -Prompt "Enter your mail adress"
Set-MsolUserPassword -UserPrincipalName $UserPrincipalName -ForceChangePasswordOnly $true -ForceChangePassword $true
Set-MsolUser -UserPrincipalName $UserPrincipalName -StrongAuthenticationRequirements $mfa
If($?)
       {
        Write-Host $User Mfa Activated -ForegroundColor Green
       } 
       Else
       {
        Write-Host $User - Error occurred -ForegroundColor Red
       }