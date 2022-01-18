function GetTestResults($username, $password, $projectId){
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))
    $buildIdUrl = "https://<teamcity_url>/app/rest/buildTypes/id:$projectId/builds?locator=count:1"
    $buildIdUrlResponse = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} $buildIdUrl
    $buildId = $buildIdUrlResponse.builds.build.id
    $stats = "https://<teamcity_url>/app/rest/builds/id:$buildId/statistics"
    $response=Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} $stats
    $response.Save('C:\response.xml')
    [xml]$ResponseDocument = Get-Content -Path C:\response.xml
    $FailedTestCount = ($ResponseDocument.properties.property | Where-Object { $_.name -eq "FailedTestCount" }).value
    $PassedTestCount = ($ResponseDocument.properties.property | Where-Object { $_.name -eq "PassedTestCount" }).value
}
$env:username = '<teamcity_username>'
$env:password = '<teamcity_password>'
GetTestResults $env:username $env:password "<teamcity_project_id>"