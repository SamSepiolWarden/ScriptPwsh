Connect-MicrosoftTeams
$User = Read-Host "Enter the Name of the mailbox to add"

$UserInParis = Get-Team -GroupId b2e6ef79-7d1d-4e72-b027-fb8caa25202a | Get-TeamUser  | Where-Object {$_.User -eq $User}
if($UserInParis)
{Write-Host $User is already a member of Paris -ForegroundColor Red}
else {
    Write-Host $User is not a member of Paris -ForegroundColor Green
}
$UserInLyon = Get-Team -GroupId b7e7d611-2ec3-479e-afec-bcedb0aadfb4 | Get-TeamUser | Where-Object {$_.User -eq $User}
if($UserInLyon)
{Write-Host $User is already a member of Lyon -ForegroundColor Red}
else {
    Write-Host $User is not a member of Lyon -ForegroundColor Green
}
$Office = [System.Management.Automation.Host.ChoiceDescription]::new('&Office')
$Office.HelpMessage = 'Get running OfficeDL'
$Paris = New-Object System.Management.Automation.Host.ChoiceDescription '&Paris' , 'Get running ParisDL'
$Lyon = New-Object System.Management.Automation.Host.ChoiceDescription '&Lyon' , 'Get running LyonDL'
$options = [System.Management.Automation.Host.ChoiceDescription[]]($Paris, $Lyon)
$Result = $host.UI.PromptForChoice('Task Menu', 'Select a Location', $options , 0)

switch($Result)
{
    0 { $Location = 'Paris' }
    1 { $Location = 'Lyon' }
}

If($Location -eq 'Paris')
{Add-TeamUser -GroupId b2e6ef79-7d1d-4e72-b027-fb8caa25202a -User $User -Role Member}
if($Location -eq 'Paris')
{
Write-Host $User Succesfully added -ForegroundColor Green
}
else
{
Write-Host Skip this team -ForegroundColor Gray
}
If($Location -eq 'Lyon') 
{Add-TeamUser -GroupId b7e7d611-2ec3-479e-afec-bcedb0aadfb4 -User $User -Role Member}
if($Location -eq 'Lyon')
{
Write-Host $User Succesfully added -ForegroundColor Green
}
else
{
Write-Host Skip this team -ForegroundColor Gray
}
Disconnect-MicrosoftTeams