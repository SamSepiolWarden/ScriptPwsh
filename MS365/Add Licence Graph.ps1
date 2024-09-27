# Connect to Microsoft Graph
Connect-MgGraph

# Import csv with users to add licenses
$users = Import-Csv -Path "C:\Test\UsersToAssigned.csv"

# Fetch available licenses
$licences = Get-MgUser -All:$true | Select-Object -ExpandProperty AssignedLicenses | Select-Object -ExpandProperty AccountSkuId -Unique

# List available licenses
Write-Host "$licences"

# Ask which license to assign
$licenceToAssign = Read-Host "Which licence do you want to assign?"

# Loop through each user and assign the license
foreach ($user in $users) {
    $operationSuccess = $true
    try {
        Set-MgUserLicense -UserId $user.UserPrincipalName -AddLicenses @{SkuId = "$licenceToAssign"} -RemoveLicenses @()
    } catch {
        $operationSuccess = $false
    }
    
    if ($operationSuccess) {
        Write-Host "License $licenceToAssign assigned to $($user.UserPrincipalName)" -ForegroundColor Green
    } else {
        Write-Host "License $licenceToAssign not assigned to $($user.UserPrincipalName)" -ForegroundColor Red
    }
}

# Disconnect from Microsoft Graph
Disconnect-MgGraph
