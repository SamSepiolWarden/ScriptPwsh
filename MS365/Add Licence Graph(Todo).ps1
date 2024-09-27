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
    Write-Host "SKU ID: $($licence.SkuId) | SKU Part Number: $($licence.SkuPartNumber) | Consumed Units: $($licence.ConsumedUnits) | Prepaid Units: $($licence.PrepaidUnits) | Capability Status: $($licence.CapabilityStatus)"
}

# Ask which license to assign
$licenceToAssign = Read-Host "`Which licence do you want to assign? (Choose SKu ID)"

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
