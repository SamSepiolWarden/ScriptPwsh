Connect-MsolService
$fname = Read-Host -Prompt 'Write the First Name'
$lname = Read-Host -Prompt 'Write the Last Name'
$Username = Read-Host -Prompt 'Writ the Username (First part of email adress - ie: Jane.Doe)'
$email = "$username@sociabble.com"
$DisplayName = Read-Host -Prompt 'Write the Display Name'
New-MsolUser -DisplayName "$DisplayName" -FirstName "$fname" -LastName "$lname" -UserPrincipalName "$email" -UsageLocation FR
Set-MsolUserLicense -UserPrincipalName $email -AddLicenses 'azureechoboostbrainsonic491:SPE_E3'
[Microsoft.Online.Administration.Automation.ConnectMsolService]::ClearUserSessionState()