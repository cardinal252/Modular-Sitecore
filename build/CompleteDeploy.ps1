param(
    [string]$msbuildTarget = "Rebuild",
    [string]$msbuildConfiguration = "Debug",
    [string]$publishProfile = "Dev",
    [string]$msBuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\MSBuild.exe"
)

$solutions = Get-ChildItem ./ -Filter "*.sln" -Recurse
$msbuildOptions = "/p:DeployWebsite=true /p:PublishProfile=Dev"

ForEach($solution in $solutions){
    Write-Output "`r`n***** Building $($solution.FullName)`r`n"
    ##### TODO: Sort out error handling #####
    cmd.exe /C "nuget restore $($solution.FullName)"
    cmd.exe /C """$msBuildPath"" $($solution.FullName) /t:$msbuildTarget $msbuildOptions"
}