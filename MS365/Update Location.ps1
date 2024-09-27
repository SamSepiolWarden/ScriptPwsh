Connect-MsolService

# Prompt for the location of the user
$location = Read-Host -Prompt "Enter the location of the user (Lyon, Paris, Mumbai, New York)"

# Import csv file
$users = Import-Csv -Path "C:\Test\Users$location.csv"

# Loop through each user in the csv file
foreach ($user in $users) {
    try {
        # Set the location for the user
        Set-MsolUser -UserPrincipalName $user.UserPrincipalName -Office $Location

        # If the above command is successful
        Write-Host "The location office of $($user.UserPrincipalName) is updated to $location" -ForegroundColor Green
    } catch {
        # If there's an error in the command
        Write-Host "The location office of $($user.UserPrincipalName) is not updated to $location. Error: $_" -ForegroundColor Red
    }
}

