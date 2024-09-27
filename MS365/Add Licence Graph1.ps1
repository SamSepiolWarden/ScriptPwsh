# Connect to Microsoft Graph
Connect-MgGraph

# Import csv with users to add licenses
$users = Import-Csv -Path "C:\Test\UsersToAssigned.csv"

# Fetch available licenses
$licences = Get-MgSubscribedSku -All:$true

# Debugging Output: Nicely formatted license list
Write-Host "Debug: Available Licenses"
Write-Host "-------------------------"
foreach ($licence in $licences) {
    Write-Host "SKU ID: $($licence.SkuId) | SKU Part Number: $($licence.SkuPartNumber)"
}

# List available licenses with better formatting
Write-Host "List of Available Licenses (by Account ID):"
Write-Host "-------------------------------------------"
foreach ($licence in $licences) {
    Write-Host $licence.AccountId -ForegroundColor Green
}

# Ask which license to assign
$licenceToAssign = Read-Host "`nWhich licence do you want to assign?"

# Initialize counters for successful and failed operations
$successCount = 0
$failureCount = 0

# Loop through each user and assign the license
foreach ($user in $users) {
    $operationSuccess = $true
    try {
        Set-MgUserLicense -UserId $user.UserPrincipalName -AddLicenses @{SkuId = "$licenceToAssign"} -RemoveLicenses @()
    } catch {
        $operationSuccess = $false
    }

    if ($operationSuccess) {
        Write-Host "License $licenceToAssign successfully assigned to $($user.UserPrincipalName)" -ForegroundColor Green
        $successCount++
    } else {
        Write-Host "License $licenceToAssign failed to assign to $($user.UserPrincipalName)" -ForegroundColor Red
        $failureCount++
    }
}

# Show summary
Write-Host "`nOperation Summary:"
Write-Host "------------------"
Write-Host "Total Licenses Assigned Successfully: $successCount" -ForegroundColor Green
Write-Host "Total Licenses Failed to Assign: $failureCount" -ForegroundColor Red

# Disconnect from Microsoft Graph
Disconnect-MgGraph
