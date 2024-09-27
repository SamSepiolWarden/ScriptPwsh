Connect-MgGraph

# Get all licensed user properties
$users = Get-MgUser -All:$true | 
    Where-Object {$_.Mail -like "*sociabble.com"} | 
    Select-Object DisplayName, Mail, @{
        Name = 'UserLogin'; 
        Expression = {
            $names = $_.DisplayName -split " "
            "$($names[0]).$($names[1])"
        }
    }

# Export to CSV
$users | Export-Csv -Path "C:\Test\UserGlpi.csv" -NoTypeInformation
if ($?) {
    Write-Host "Users Successfully Exported" -ForegroundColor Green
} else {
    Write-Host "You had some error in export" -ErrorAction Stop -ForegroundColor Red
}

Disconnect-MgGraph
