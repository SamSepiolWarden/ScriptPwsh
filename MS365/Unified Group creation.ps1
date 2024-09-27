Connect-ExchangeOnline
$DisplayName = Read-Host -Prompt "Enter the group Display name"
$Alias = Read-Host -Prompt "Enter the group alias"
$Email = Read-Host -Prompt "Enter the mail adress of the group"
New-UnifiedGroup -DisplayName "$DisplayName" -Alias $Alias -PrimarySmtpAddress "$Email" -Confirm:$true
if($?)
{Write-Host Group Sucessfully Created -ForegroundColor Green}
else
{Write-Host -ErrorAction Stop -ForegroundColor Red}

$AccessType = Read-Host -Prompt "Enter the type of access (Public or Private)"
Set-UnifiedGroup -Identity "$Alias" -AccessType $AccessType -Confirm:$true
if($?)
{Write-Host Group set to $AccessType -ForegroundColor Green}
else
{Write-Host -ErrorAction Stop -ForegroundColor Red}

$Member = Read-Host -Prompt "Entre the name of the Member/Owner"
Add-UnifiedGroupLinks -Identity "$Alias" -LinkType Member -Links "$Member"
if($?)
{Write-Host Members Sucessfully Add -ForegroundColor Green}
else
{Write-Host -ErrorAction Stop -ForegroundColor Red}
$Owner = Read-Host -Prompt "Enter the name of the Owner"
Add-UnifiedGroupLinks -Identity "$Alias" -LinkType Owner -Links "$Owner" -Confirm:$true
if($?)
{Write-Host Owner Sucessfully Add -ForegroundColor Green}
else
{Write-Host -ErrorAction Stop -ForegroundColor Red}
While($Members = $true)
{$Members = Read-Host -Prompt "Entre the name of the other Members or CTRL + C to break"
Add-UnifiedGroupLinks -Identity "$Alias" -LinkType Member -Links "$Members" -Confirm:$true
if($?)
{Write-Host Members Sucessfully Add -ForegroundColor Green}
else
{Write-Host -ErrorAction Stop -ForegroundColor Red}}
Disconnect-ExchangeOnline

