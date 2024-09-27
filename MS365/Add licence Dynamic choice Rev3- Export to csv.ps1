# Se connecter à Office 365
Connect-MsolService

$Teams = New-Object System.Management.Automation.Host.ChoiceDescription '&Teams' , 'Add Teams Licence'
$Office = New-Object System.Management.Automation.Host.ChoiceDescription '&Office' , 'Add O365 Licence'
$PowerBiPro = New-Object System.Management.Automation.Host.ChoiceDescription '&PowerBiPro' , 'Add PowerBi Licence'
$PowerBiSt = New-Object System.Management.Automation.Host.ChoiceDescription '&PowerBiSt' , 'Add Power Bi Standard Licence'
$Sharepoint = New-Object System.Management.Automation.Host.ChoiceDescription '&Sharepoint' , 'Add Sharepoint Storage Licence'
$Flow = New-Object System.Management.Automation.Host.ChoiceDescription '&Flow' , 'Add Flow Licence'
$Tvm = New-Object System.Management.Automation.Host.ChoiceDescription '&Tvm' , 'Add Tvm Licence'
$PowerAppsDev = New-Object System.Management.Automation.Host.ChoiceDescription '&PowerAppsDev' , 'Add Power App Licence' 
$options = [System.Management.Automation.Host.ChoiceDescription[]]($Teams, $Office, $PowerBiPro, $PowerBiSt, $Sharepoint, $Flow, $Tvm, $PowerAppsDev)
$Result = $host.UI.PromptForChoice('Task Menu', 'Select a Licence', $options , 0)

$accountSkuId = ""
switch($Result)
{
    0 { $accountSkuId = "azureechoboostbrainsonic491:TEAMS_EXPLORATORY" } # Licence Teams
    1 { $accountSkuId = "azureechoboostbrainsonic491:SPE_E3" } # Licence Office 365
    2 { $accountSkuId = "azureechoboostbrainsonic491:POWER_BI_PRO" } # Licence Microsoft 365
    3 { $accountSkuId = "azureechoboostbrainsonic491:POWER_BI_STANDARD" } # Licence Intune
    4 { $accountSkuId = "azureechoboostbrainsonic491:SHAREPOINTSTORAGE" } # Licence Threat
    5 { $accountSkuId = "azureechoboostbrainsonic491:FLOW_FREE" } # Licence Power automate
    6 { $accountSkuId = "azureechoboostbrainsonic491:TVM_Premium_Standalone" } # Licence Vulnerability Management
    7 { $accountSkuId = "azureechoboostbrainsonic491:POWERAPPS_DEV" } # Licence Cloud App
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

