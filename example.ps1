function GetTestResults($username, $password, $projectId, $stage){
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))
    $buildIdUrl = "https://<teamcity_url>/app/rest/buildTypes/id:$projectId/builds?locator=count:1"
    $buildIdUrlResponse = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} $buildIdUrl
    $buildId = $buildIdUrlResponse.builds.build.id
    $stats = "https://<teamcity_url>/app/rest/builds/id:$buildId/statistics"
    $response=Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} $stats
    $response.Save('C:\response.xml')
    [xml]$ResponseDocument = Get-Content -Path C:\response.xml
    $FailedTestCount = ($ResponseDocument.properties.property | Where-Object { $_.name -eq "FailedTestCount" }).value
    if( !$FailedTestCount ){
        $FailedTestCount = 0
    }
    $PassedTestCount = ($ResponseDocument.properties.property | Where-Object { $_.name -eq "PassedTestCount" }).value
    if( !$PassedTestCount ){
        $PassedTestCount = 0
    }
    try {
        $percentage = [math]::Round(($PassedTestCount/($PassedTestCount + $FailedTestCount)) * 1000, 2)
    }
    catch {
        $percentage = 0
    }
    $item = [pscustomobject][ordered]@{Stage=$stage;Passed=$PassedTestCount;Failed=$FailedTestCount;"Percentage Passed"=""+$percentage+"%"}
    $script:table += $item
}
$env:username = '<teamcity_username>'
$env:password = '<teamcity_password>'
$table = @()
GetTestResults $env:username $env:password "<teamcity_project_id>" "<stage_name_for_table_coloumn>"
GetTestResults $env:username $env:password "<teamcity_project_id>" "<stage_name_for_table_coloumn>"
GetTestResults $env:username $env:password "<teamcity_project_id>" "<stage_name_for_table_coloumn>"
GetTestResults $env:username $env:password "<teamcity_project_id>" "<stage_name_for_table_coloumn>"
GetTestResults $env:username $env:password "<teamcity_project_id>" "<stage_name_for_table_coloumn>"
$Header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
"@
$table.GetEnumerator() | Select-Object Stage, Passed, Failed, "Percentage Passed" | ConvertTo-Html -head $Header | Out-File -FilePath .\report.html