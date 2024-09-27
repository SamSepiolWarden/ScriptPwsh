Connect-ExchangeOnline
$User = Read-Host "Enter Name of the mailbox to remove"
Try {
    $Mbx = Get-Mailbox -Identity $User -ErrorAction Stop | Select -ExpandProperty PrimarySmtpAddress}
Catch {
    Write-Host "No mailbox can be found called" $User; break }
$Services = [System.Management.Automation.Host.ChoiceDescription]::new('&Services')
$Services.HelpMessage = 'Get running services'
$CSM = New-Object System.Management.Automation.Host.ChoiceDescription '&CSM', 'Get running CSMDL'
$HR = New-Object System.Management.Automation.Host.ChoiceDescription '&HR', 'Get running HRDL'
$Legal = New-Object System.Management.Automation.Host.ChoiceDescription '&Legal', 'Get running LegalDL'
$Marketing = New-Object System.Management.Automation.Host.ChoiceDescription '&Marketing', 'Get running MarketingDL'
$Product = New-Object System.Management.Automation.Host.ChoiceDescription '&Product', 'Get running ProductDL'
$Sales = New-Object System.Management.Automation.Host.ChoiceDescription '&Sales', 'Get running SalesDL'
$Tech = New-Object System.Management.Automation.Host.ChoiceDescription '&Tech', 'Get running TechDL'
$Quit = New-Object System.Management.Automation.Host.ChoiceDescription '&Quit', 'Quit menu'
$options = [System.Management.Automation.Host.ChoiceDescription[]]($CSM, $HR, $Legal, $Marketing, $Product, $Sales, $Tech, $Quit)
$Result = $host.UI.PromptForChoice('Task menu', 'Select a Department', $options , 0 )

switch($result)
{
    0 { $Department = "CSM"}
    1 { $Department = "HR"}
    2 { $Department = "Legal"}
    3 { $Department = "Marketing"}
    4 { $Department = "Product"}
    5 { $Department = "Sales"}
    6 { $Department = "Tech" }
    7 { $Quit = Exit }

}
#############################################

$DLs = Import-Csv -Path "$PWD\DL\DL-$Department.csv"
ForEach ($DL in $DLs) {
     Try {
       Remove-DistributionGroupMember -Identity $DL."DL" -Member $User -ErrorAction Continue }
      Catch {
        Write-Host "Couldn't remove" $User "to DL" (Get-DistributionGroup -Identity $DL."DL").DisplayName }
       If($?)
       {
        Write-Host $User Succesfully remove -ForegroundColor Green
       } 
       Else
       {
        Write-Host $User - Error occurred -ForegroundColor Red
       }
}

#########
# Ici code pour Groupes Teams
Connect-MicrosoftTeams
$TeamsAdd = Import-Csv -Path "$PWD\Teams\Teams-$Department.csv"
Foreach($TeamUser in $TeamsAdd) 

{
$TeamName = $TeamUser.'TeamName'
$GroupId = $TeamUser."GroupId"
$Role = $TeamUser.'Role'
 try {
$i++;
Write-Progress -activity "Processing $TeamName - $Role" -status "$i out of $TotolRows completed"
    
Remove-TeamUser -GroupId $GroupId -User $User}
    
catch {
    {
    Write-Host $User Succesfully remove -ForegroundColor Green
    }
    {
    Write-Host "Error occurred for $GroupId - $User" -f Yellow
    }

}
Finally {
Disconnect-ExchangeOnline
Disconnect-MicrosoftTeams}
}
