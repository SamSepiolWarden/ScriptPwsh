Connect-SPOService
$User = Read-Host -Prompt "Enter the mail adress"
Remove-SPOUser -Site https://sociabble.sharepoint.com -LoginName $User
{
 If($?)
       {
        Write-Host "$User Succesfully added" -ForegroundColor Green
       }
Else
       {
        Write-Host $User - Error occurred -ForegroundColor Red
       }
}