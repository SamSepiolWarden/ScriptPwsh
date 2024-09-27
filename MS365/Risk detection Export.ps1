Connect-MgGraph

#list all risk detections
$Risk = get-mgriskdetection -filter "(RiskState ne 'dismissed') and (RiskState ne 'remediated')"

#export to a csv
$Risk | Export-Csv -Path "c:\Test\RiskDetections.csv"