Connect-MsolService
$Users = Import-Csv -Path 'C:\Users\GregorySemedo\Downloads\users_1_16_2023.csv'
foreach ($user in $Users) {
Set-MsolUserLicense -UserPrincipalName $user.'User principal name' -AddLicenses "azureechoboostbrainsonic491:TVM_Premium_Standalone"
If($?)
       {
        Write-Host "$($user.UserPrincipalName) Succesfully added to Licence" -ForegroundColor Green
       } 
       Else
       {
        Write-Host "$($user.UserPrincipalName) failed to be added to Licence" -ForegroundColor Red
       }}