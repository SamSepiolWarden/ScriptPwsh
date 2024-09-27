Connect-MsolService

$Fname = Read-Host -Prompt "Enter the First Name of the user to add"
$Lname = Read-Host -Prompt "Enter the Last Name of the user to add"
$Username = Read-Host -Prompt "Enter the email of the user to add "
Connect-AzureAD
# Lister les departement disponible
$Departements = Get-AzureADUser | Select-Object -ExpandProperty Department | Sort-Object -Unique
foreach ($Departement in $Departements)
{
    Write-Host $Departement
}

$Department = Read-Host -Prompt "Enter the Department of the user to add"
$Location = Read-Host -Prompt "Enter the Office location of the user to add (Paris, Lyon...)"

$Displayname = $Fname + " " + $Lname
$Strong = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
    $Strong.RelyingParty = "*"
    $Strong.State = "Enforced"
$StrongMFA = $Strong
$UsageLocation = Read-Host -Prompt "Enter the Usage location of the user (US,FR)"
$Password = Read-Host -Prompt "Enter the password of the user to add" 
# Create a new user
New-MsolUser -DisplayName $Displayname -FirstName $Fname -LastName $Lname -UserPrincipalName $Username -Department $Department -ForceChangePassword $true -Password $Password -Office $Location -ErrorAction SilentlyContinue 
Set-MsolUser -UserPrincipalName $Username -UsageLocation $UsageLocation


# Check if the user was created successfully
if ($?)
{
    # Check if there are licenses available
    
        Set-MsolUserLicense -UserPrincipalName $Username -AddLicenses "azureechoboostbrainsonic491:SPE_E3" 
        if ($?) {
            Write-Host "Licence assigned to $Username" -ForegroundColor Green
        }
        else {
            Write-Host "No more licences available" -ForegroundColor Red
        }
        Set-MsolUserLicense -UserPrincipalName $Username -AddLicenses "azureechoboostbrainsonic491:TVM_Premium_Standalone"
        if ($?) {
            Write-Host "Licence assigned to $Username" -ForegroundColor Green
        }
        else {
            Write-Host "No more licences available" -ForegroundColor Red
        }
    
    
}
else
{
    Write-Error -ErrorRecord -ForegroundColor Red
}

Start-Sleep -Seconds 5

Set-MsolUser -UserPrincipalName $Username -StrongAuthenticationRequirements $StrongMFA
if($?)
{
    Write-Host "MFA for $Username Enabled" -ForegroundColor Green
}
else {
    Write-Host "Mfa for $Username not enable" -ForegroundColor Red -ErrorAction
}

# Search for the new user id
$Search = Get-MsolUser -UserPrincipalName $Username
foreach($user in $Search){
    if($user.UserPrincipalName -eq $Username){
        $IDCreation = $user.ObjectId
    }
}

Connect-Mggraph
# Add the manager to the user
$Manager = Read-Host -Prompt "Enter the Display name of the manager to add"
$ManagerId = (Get-Mguser -Filter "DisplayName eq '$Manager'").id

$Params = @{
    "@odata.id" = "https://graph.microsoft.com/v1.0/users/$ManagerId"
} | ConvertTo-Json


Set-MgUserManagerByRef -UserId $IDCreation  -BodyParameter $Params
if ($?) {
    Write-Host "Manager $Manager assigned to $Username" -ForegroundColor Green
}
else {
    Write-Host "Manager $Manager not assigned to $Username" -ForegroundColor Red
}
Disconnect-Mggraph
Disconnect-AzureAD

Connect-ExchangeOnline

# $Alias = $Fname + "." + $Lname
Start-Sleep -Seconds 5

# Set the alias of the user
# $Identity = Read-Host -Prompt "Enter the display of the user to add the alias"
# Set-Mailbox -Identity "$Identity" -EmailAddresses @{Add="$Alias@azureechoboostbrainsonic491.onmicrosoft.com"}
# if ($?) {
#    Write-Host "Alias $Alias assigned to $Username" -ForegroundColor Green
#}
#else {
    #Write-Host "Alias $Alias not assigned to $Username" -ForegroundColor Red
#}

Start-Sleep -Seconds 5

# block credential of the user
Set-MsolUser -UserPrincipalName $Username -BlockCredential $true
if ($?) {
    Write-Host "Credential blocked for $Username" -ForegroundColor Green
}
else {
    Write-Host "Credential not blocked for $Username" -ForegroundColor Red
}

Disconnect-ExchangeOnline


