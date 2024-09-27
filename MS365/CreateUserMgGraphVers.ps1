Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All", "UserAuthenticationMethod.ReadWrite.All"
Connect-MsolService

# Prompt for the user's email adress to create
$email = Read-Host -Prompt "Enter the email address of the user to create"
$FirstName = Read-Host -Prompt "Enter the first name of the user to create"
$LastName = Read-Host -Prompt "Enter the last name of the user to create"
$Password = Read-Host -Prompt "Enter the password of the user to create" -AsSecureString

$PasswordProfile = @{
    "Password" = $Password
    "ForceChangePasswordNextSignIn" = $true
}

$UsageLocation = Read-Host -Prompt "Enter the usage location of the user to create"
# Lister les departement disponible
$Departements = Get-MgBetaUser -All | Select-Object -ExpandProperty Department | Sort-Object -Unique
foreach ($Departement in $Departements)
{
    Write-Host $Departement
}

$Department = Read-Host -Prompt "Enter the Department of the user to add"
# Create the user
New-MgUser -UserPrincipalName $email -DisplayName "$FirstName $LastName" -PasswordProfile $PasswordProfile -AccountEnabled:$false -MailNickname "$FirstName.$LastName" -Department $Department -GivenName $FirstName -Surname $LastName

if ($?) {

$CheckUser = Get-MgUser -Filter "UserPrincipalName eq '$email'"
if($null -ne $CheckUser) {
Write-Host "User created successfully" -ForegroundColor Green
Update-MgUser -UserID $CheckUser.Id-UsageLocation $UsageLocation
if ($?) {
Write-Host "Usage location set successfully" -ForegroundColor Green
}
else {
Write-Host "Failed to set usage location" -ForegroundColor Red
}
}
else {
Write-Host "Failed to create user" -ForegroundColor Red
}
}

#Get all licences available
$AllLicences = Get-MgSubscribedSku
$AllLicences | Select-Object SkuPartNumber, SkuId
foreach ($Licence in $AllLicences) {
Write-Host "Licence: $($Licence.SkuPartNumber) - $($Licence.SkuId)"
}
# Check if the user was created successfully
do {
    if ($?)
    {
        $Licence = [System.Management.Automation.Host.ChoiceDescription]::new('&Office')
        $OfficeE3 = New-Object System.Management.Automation.Host.ChoiceDescription '&OfficeE3', 'Get assigned OfficeE3'
        $TVM = New-Object System.Management.Automation.Host.ChoiceDescription '&TVM', 'Get assigned TVM'
        $PowerBiPro = New-Object System.Management.Automation.Host.ChoiceDescription '&PowerBiPro', 'Get assigned PowerBiPro'
        $options = [System.Management.Automation.Host.ChoiceDescription[]]($OfficeE3, $TVM, $PowerBiPro)
        $Result = $host.UI.PromptForChoice('Task Menu', 'Select a Licence', $options, 0)

        switch ($Result) {
            0 { $Licence = Read-Host -Prompt "Enter the licence ID of office E3"}
            1 { $Licence = Read-Host -Prompt "Enter the licence ID of TVM"}
            2 { $Licence = Read-Host -Prompt "Enter the licence ID of PowerBiPro"}
        }

        $UserFilter = Get-MgUser -Filter "UserPrincipalName eq '$email'" 
        # Check if there are licenses available
Start-Sleep -Seconds 5
        Set-MgUserLicense -UserId $UserFilter.Id -AddLicenses @{ SkuId = "$Licence" } -RemoveLicenses @()
        if ($?) {
            Write-Host "Licence assigned to $Username" -ForegroundColor Green
        } else {
            Write-Host "No more licences available or error occurred" -ForegroundColor Red
        }
    }
    else
    {
        Write-Host "An error occurred." -ForegroundColor Red
    }

    $Ask = Read-Host -Prompt "Do you want to add another licence? (Y/N)"
} while ($Ask -eq 'Y')
Start-Sleep -Seconds 5
# Add the manager to the user
$Manager = Read-Host -Prompt "Enter the Display name of the manager to add"
$ManagerId = (Get-Mguser -Filter "DisplayName eq '$Manager'").id

$Params = @{
    "@odata.id" = "https://graph.microsoft.com/v1.0/users/$ManagerId"
} | ConvertTo-Json


Set-MgUserManagerByRef -UserId $UserFilter.Id  -BodyParameter $Params
if ($?) {
    Write-Host "Manager $Manager assigned to $Username" -ForegroundColor Green
}
else {
    Write-Host "Manager $Manager not assigned to $Username" -ForegroundColor Red
}

# Enforce MFA for the user
$Mfa = Read-Host -Prompt "Do you want to enforce MFA for the user? (Y/N)"

if ($Mfa -eq 'Y') {
    $Strong = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
    $Strong.RelyingParty = "*"
    $Strong.State = "Enforced"
$StrongMFA = $Strong

    Set-MsolUser -UserPrincipalName $email -StrongAuthenticationRequirements $StrongMFA
    Write-Host "MFA enforced for user $email" -ForegroundColor Green
if ($Mfa -eq 'N') {
    
    Write-Host "MFA not enforced for user $email" -ForegroundColor Red
}
    
}
#Initialise varaibale ask2
$Ask2 = 'Y'

# add a loop to add a user to another group
while ($Ask2 -eq 'Y') {
    
# add the user to a group
$Group = Get-MgGroup -Filter "DisplayName eq 'EndPoint - Alpha Deployment'"
$GroupId = (Get-MgGroup -Filter "DisplayName eq '$Group'").id
 New-MgGroupMember -GroupId $GroupId -DirectoryObjectID $UserFilter.Id
 if($?) {
     Write-Host "User $email added to group $Group" -ForegroundColor Green
 }
 else {
     Write-Host "User $email not added to group $Group" -ForegroundColor Red
 }
$Ask2 = Read-Host -Prompt "Do you want to add the user to another group? (Y/N)"
}


#Disconnect-MgGraph
Disconnect-MgGraph