## Powershell Script To Download Tests Results Using Teamcity API

This template Powershell script can be used to fetch test results of as many builds. 

An `example.ps1` contains example of downloading test results and storing them in an HTML table. The example fetches test results from five different projects. You can have fewer or more depending on your needs.

### How To Use?

1) Replace your Teamcity url here:

```
$buildIdUrl = "https://<teamcity_url>/app/rest/buildTypes/id:$projectId/builds?locator=count:1"
```

2) By default, it will only fetch the most recent build. If, however, you want X builds then update count value as well.
3) Teamcity project ID can be found in the `General Settings` tab of your project.
4) You may also update other locations used in the script as per your convenience.
5) Styling can also be removed/updated by editing the CSS used in the script.
