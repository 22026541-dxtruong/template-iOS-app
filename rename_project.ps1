param(
    [string]$NewName = "MyNewApp"
)

$ErrorActionPreference = "Stop"

$projectFolder = Join-Path $PSScriptRoot "ios"
$oldFolder = Join-Path $projectFolder "MyApp"
$oldAppFile = Join-Path $oldFolder "App\MyAppApp.swift"

if (-not (Test-Path $oldFolder)) {
    Write-Error "Folder not found: $oldFolder"
    exit 1
}

$targetFolder = Join-Path $projectFolder $NewName
$targetAppFile = Join-Path $targetFolder "App\${NewName}App.swift"

if (Test-Path $targetFolder) {
    Write-Error "Folder already exists: $targetFolder"
    exit 1
}

Rename-Item -Path $oldFolder -NewName $NewName

if (Test-Path $oldAppFile) {
    Rename-Item -Path $oldAppFile -NewName "${NewName}App.swift"
}

# Update project.yml
$projectYml = Join-Path $projectFolder "project.yml"
if (Test-Path $projectYml) {
    $content = Get-Content -Path $projectYml -Raw
    $content = $content.Replace("name: MyApp", "name: $NewName")
    $content = $content.Replace("MyApp", $NewName)
    Set-Content -Path $projectYml -Value $content -NoNewline
}

# Replace text in all relevant files
Get-ChildItem -Path $projectFolder -Recurse -File |
    Where-Object {
        $_.Extension -in ".swift", ".yml", ".plist", ".entitlements", ".xcstrings"
    } |
    ForEach-Object {
        $path = $_.FullName
        $content = Get-Content -Path $path -Raw
        $newContent = $content.Replace("MyApp", $NewName)
        if ($newContent -ne $content) {
            Set-Content -Path $path -Value $newContent -NoNewline
        }
    }

# Regenerate project
Push-Location $projectFolder
xcodegen generate
Pop-Location

Write-Host "Project renamed to: $NewName"
Write-Host "Please check bundle identifier and DEVELOPMENT_TEAM in ios/project.yml"
