param(
    [string]$ProjectFolder, # ="NewModule.Feature.MyProject",
    [string]$ProjectName, # = "HelixMk2.NewModule.Feature.MyProject",
    [string]$RootNamespace = $ProjectName,
    [string]$AssemblyName = $ProjectName
)

$outputFolder = "$PSScriptRoot/Output/$ProjectFolder"

# Remove any previous incarnation
if(Test-Path "$outputFolder"){
    Remove-Item "$outputFolder" -Recurse
}

# Establish the new project file
Copy-Item "$PSScriptRoot/Template" $outputFolder -Recurse
$projectFilePath = "$outputFolder/$ProjectName.csproj" 
Move-Item "$outputFolder/Blank.csproj" $projectFilePath

$projectFileText = Get-Content $projectFilePath
$guid = [System.Guid]::NewGuid()
$projectFileText = $projectFileText.Replace("##ProjectGuid##", "{$($guid.ToString().ToUpper())}")
$projectFileText = $projectFileText.Replace("##RootNamespace##", $RootNamespace)
$projectFileText = $projectFileText.Replace("##AssemblyName##", $AssemblyName)
Set-Content $projectFilePath -Value $projectFileText