param(
    [string]$MsbuildTarget = "Build",
    [string]$MsbuildConfiguration = "Release",
    [string]$PublishProfile = "BuildServer",
    [string]$MsBuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\MSBuild.exe"
)

$solutions = Get-ChildItem $PSScriptRoot/../src -Filter "*.sln" -Recurse -File
$msbuildOptions = "/p:DeployWebsite=true /p:PublishProfile=$PublishProfile"

ForEach($solution in $solutions){
    Write-Output "`r`n***** Building $($solution.FullName)`r`n"
    ##### TODO: Sort out error handling #####
    cmd.exe /C "nuget restore $($solution.FullName)"
    cmd.exe /C """$MsBuildPath"" $($solution.FullName) /t:$MsbuildTarget /p:Configuration=$MsbuildConfiguration $msbuildOptions"
}

$outputPath = "$PSScriptRoot/../Published"
$projectOutputs = Get-ChildItem $PSScriptRoot/../src -Filter "Output.*" -Directory -Recurse

if(Test-Path $outputPath){
    Remove-Item $outputPath -Recurse
}
New-Item $outputPath -ItemType Directory
ForEach($projectOutput in $projectOutputs){
    Write-Output "`r`n***** Collecting $($projectOutput.FullName)`r`n"
    Move-Item $projectOutput.FullName "$outputPath/$($projectOutput.Name)"
}


$deployedDirectories = Get-ChildItem $outputPath -Directory

$dictionary = New-Object "System.Collections.Generic.Dictionary[string, string]"
ForEach($deployedDirectory in $deployedDirectories){
    $deployedFiles = Get-ChildItem $deployedDirectory.FullName -File -Recurse

    ForEach($deployedFile in $deployedFiles){
        $relativePath = $deployedFile.FullName.Replace("$($deployedDirectory.FullName)\","")
        if($dictionary.ContainsKey($relativePath)){
            Write-Error "The file $relativePath is supplied in both $($dictionary[$relativePath]) and $($deployedDirectory.Name)"
            Exit -1
        }
        $dictionary.Add($relativePath, $deployedDirectory.Name)
    }    
    Write-Output "***** $($deployedDirectory.Name) is Clean *****"
}
Write-Output "*** ALL CLEAN ***"