Connect-MsolService

$PowerBi = New-Object System.Management.Automation.Host.ChoiceDescription '&PowerBi' , 'Add Licence PowerBiPro'
$OfficeE3 = New-Object System.Management.Automation.Host.ChoiceDescription '&OfficeE3' , 'Add Licence OfficeE3'
$Sharepoint = New-Object System.Management.Automation.Host.ChoiceDescription '&Sharepoint' , 'Add Licence Sharepoint'
$BetaOffice = New-Object System.Management.Automation.Host.ChoiceDescription '&BetaOffice' , 'Add Licence Office'

$options = [System.Management.Automation.Host.ChoiceDescription[]]($PowerBi, $OfficeE3, $Sharepoint, $BetaOffice)
$Result = $host.UI.PromptForChoice('Task Menu', 'Select a Licence', $options , 0)

$accountSkuIds = ""
switch($Result)
{
    0 { $accountSkuIds = 'FsoAllsafe:POWER_BI_PRO' } #Licence PowerBiPro
    1 { $accountSkuIds = 'FsoAllsafe:SPE_E3' } #Licence OfficeE3
    2 { $accountSkuIds = 'FsoAllsafe:SHAREPOINTSTORAGE' } #Licence Sharepoint
    3 { $accountSkuIds = 'FsoAllsafe:OFFICESUBSCRIPTION' } #Licence Office
}

$Licence = Get-MsolAccountSku | Where-Object {$_.$accountSkuId -eq $accountSkuIds}

if ( $Licence.ActiveUnits - $Licence.ConsumedUnits -gt 0 )
{
    #Get the user to add
$User = Read-Host -Prompt "Enter the Name of the mailbox to add"
#Add the licence
Set-MsolUserLicense -UserPrincipalName $User -AddLicenses $accountSkuIds 
Write-Host $User $Licence Succesfully added -ForegroundColor Green}
    else { Write-Host "No licence available" -ForegroundColor Red
    }



