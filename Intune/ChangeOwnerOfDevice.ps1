Connect-MgGraph

do {
    # Search for enrolled device by name
    $DeviceName = Read-Host -Prompt "Enter the device name to search for"
    $Devices = Get-MgDeviceManagementManagedDevice -Filter "DeviceName eq '$DeviceName'" | Select-Object DeviceName, Id, userPrincipalName, UserId

    if ($null -eq $Devices) {
        Write-Output "No devices found with the name $DeviceName"
        continue
    }

    $Devices | Format-Table -AutoSize
    $DeviceId = Read-Host -Prompt "Enter the Intune Device ID (Id column) of the device to set a new primary user for"

    # Ask for the UPN of the new primary user
    $UPN = Read-Host -Prompt "Enter the UPN of the user to set as the primary user for the selected device"
    $User = Get-MgUser -Filter "UserPrincipalName eq '$UPN'" | Select-Object Id, UserPrincipalName, DisplayName

    if ($null -eq $User) {
        Write-Output "No users found with the UPN $UPN"
        continue
    }

    # If more than one user is found, prompt for the UserId
    if ($User.Count -gt 1) {
        Write-Output "More than one user found with the UPN $UPN"
        $User | Format-Table -AutoSize
        $UserId = Read-Host -Prompt "Confirm the UserId"
    }
    else {
        $UserId = $User.Id
    }

    # Build the body for Graph request
    $Body = "{'@odata.id':'https://graph.microsoft.com/beta/users/$UserId'}"

    # Build the URI for Graph request
    $URI = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices('$DeviceId')/users/`$ref"

    try {
        # Set primary user for the device
        Invoke-MgGraphRequest -Method POST -Uri $URI -Body $Body
        Write-Host "Successfully set the primary user for the device $DeviceName to $UPN" -ForegroundColor Cyan
    }
    catch {
        Write-Output "$($_.Exception.Message)"
    }

    # Ask if the user wants to repeat the process for another device
    $Repeat = Read-Host -Prompt "Do you want to set a primary user for another device? (y/n)"

} while ($Repeat -eq 'y')
