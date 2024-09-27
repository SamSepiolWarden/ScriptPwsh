# Se connecter à Office 365
Connect-MsolService

$Teams = New-Object System.Management.Automation.Host.ChoiceDescription '&Teams' , 'Add Teams Licence'
$Office = New-Object System.Management.Automation.Host.ChoiceDescription '&Office' , 'Add O365 Licence'
$Microsoft = New-Object System.Management.Automation.Host.ChoiceDescription '&Microsoft' , 'Add Microsoft Licence'
$Intune = New-Object System.Management.Automation.Host.ChoiceDescription '&Intune' , 'Add Intune Licence'
$Threat = New-Object System.Management.Automation.Host.ChoiceDescription '&Threat' , 'Add Threat Licence'
$Flow = New-Object System.Management.Automation.Host.ChoiceDescription '&Flow' , 'Add Flow Licence'
$Tvm = New-Object System.Management.Automation.Host.ChoiceDescription '&Tvm' , 'Add Tvm Licence'
$CloudApp = New-Object System.Management.Automation.Host.ChoiceDescription '&CloudApp' , 'Add CloudApp Licence' 
$options = [System.Management.Automation.Host.ChoiceDescription[]]($Teams, $Office, $Microsoft, $Intune, $Threat, $Flow, $Tvm, $CloudApp)
$Result = $host.UI.PromptForChoice('Task Menu', 'Select a Licence', $options , 0)

$accountSkuId = ""
switch($Result)
{
    0 { $accountSkuId = "FsoAllSafe:TEAMS_EXPLORATORY" } # Licence Teams
    1 { $accountSkuId = "FsoAllSafe:O365_BUSINESS_PREMIUM" } # Licence Office 365
    2 { $accountSkuId = "FsoAllSafe:M365_DISC0VER_RESPOND" } # Licence Microsoft 365
    3 { $accountSkuId = "FsoAllSafe:Microsoft_Intune_Suite" } # Licence Intune
    4 { $accountSkuId = "FsoAllSafe:THREAT_INTELLIGENCE" } # Licence Threat
    5 { $accountSkuId = "FsoAllSafe:FLOW_FREE" } # Licence Power automate
    6 { $accountSkuId = "FsoAllSafe:TVM_Premium_Add_on" } # Licence Vulnerability Management
    7 { $accountSkuId = "FsoAllSafe:Microsoft_Cloud_App_Security_App_Governance_Add_On" } # Licence Cloud App
}

# Récupérer l'information sur les licences
$licenses = Get-MsolAccountSku | Where-Object { $_.AccountSkuId -eq $accountSkuId }

# Créer un tableau pour stocker les utilisateurs ayant obtenu une licence
$licensedUsers = @()

if ($licenses.ActiveUnits - $licenses.ConsumedUnits -gt 0) {
    # Récupérer les utilisateurs à attribuer une licence
    $users = Get-MsolUser -All

    foreach ($user in $users) {
        if ($licenses.ActiveUnits - $licenses.ConsumedUnits -gt 0) {
            # Attribuer une licence à l'utilisateur
            Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $accountSkuId
            Start-Sleep -Seconds 5  # Attendez 5 secondes
            Write-Output "Licence attribuée à l'utilisateur $($user.UserPrincipalName)"
            # Ajouter l'utilisateur à la liste des utilisateurs ayant obtenu une licence
            $licensedUsers += $user
        } else {
            Write-Output "Plus de licences disponibles pour attribuer à l'utilisateur $($user.UserPrincipalName)"
            break
        }
    }
} else {
    Write-Output "Aucune licence disponible"
}

# Exporter les utilisateurs ayant obtenu une licence vers un fichier CSV
$licensedUsers | Export-Csv -Path C:\Test\LicencedUsers.csv -NoTypeInformation -Encoding UTF8 -Force

