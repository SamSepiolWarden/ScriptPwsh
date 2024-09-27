Connect-MicrosoftTeams
$User = Read-Host "Enter Name of the mailbox to add"

$Office = [System.Management.Automation.Host.ChoiceDescription]::new('&Office')
$Office.HelpMessage = 'Get running OfficeDL'
$Paris = New-Object System.Management.Automation.Host.ChoiceDescription '&Paris' , 'Get running ParisDL'
$Lyon = New-Object System.Management.Automation.Host.ChoiceDescription '&Lyon' , 'Get running LyonDL'
$options = [System.Management.Automation.Host.ChoiceDescription[]]($Paris, $Lyon)
$Result = $host.UI.PromptForChoice('Task Menu', 'Select a Location', $options , 0)

switch($Result)
{
    0 { $Location = "Paris" }
    1 { $Location = "Lyon" }
}
if($Location -eq 'Paris'){Add-TeamUser -GroupId 0a5a9765-a133-40eb-b463-359a1842617f -User $User -Role Member}
if($Location -eq 'Paris')
{
Write-Host $User Succesfully added -ForegroundColor Green
}
else
{
Write-Host Skip this team -ForegroundColor Gray
}

if($Location -eq 'Lyon'){Add-TeamUser -GroupId 8ec2c3bc-99f6-4b84-88b0-defbaf4b2bcf -User $User -Role Member}
if($Location -eq 'Lyon')
{
Write-Host $User Succesfully added -ForegroundColor Green
}
else
{
Write-Host Skip this team -ForegroundColor Gray
}
 
Disconnect-MicrosoftTeams
