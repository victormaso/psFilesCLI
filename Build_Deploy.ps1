
$Scripthome = $PSScriptRoot

$moduleFolder = "$Scripthome/psFilesCli"

$CrescendoBuildersCompletePath = "$Scripthome/CrescendoCommandConfigsComplete"
$CrescendoCommandsPath = "$Scripthome/CrescendoCommandConfigs"
$CrescendoBuildersPath = "$Scripthome/CrescendoBuilders"

. "$Scripthome\Build_Functions.ps1"

$globalFlagsParameters = (Get-Content "$CrescendoBuildersPath/GlobalFlags.json" | ConvertFrom-Json).commands.parameters
$StartAndEndFlagsParameters = (Get-Content "$CrescendoBuildersPath/StartAndEndFlags.json" | ConvertFrom-Json).commands.parameters
$APIPagingParameters = (Get-Content "$CrescendoBuildersPath/APIPaging.json" | ConvertFrom-Json).commands.parameters

$CrescendoBuilderFiles = Get-ChildItem $CrescendoCommandsPath -Recurse -File

new-item -ItemType Directory -Path $CrescendoBuildersCompletePath -ErrorAction SilentlyContinue
Get-ChildItem $CrescendoBuildersCompletePath | Where-Object { $_.FullName -match 'CrescendoCommandConfigsComplete(/|\\)CrescendoComplete_' } | Remove-Item -Force

$CrescendoBuilderFiles | ForEach-Object {
    write-host "$($_.fullname)"
    $psobjectofCresendoCommandConfig = (Get-Content $_.FullName | ConvertFrom-Json)

    $commandConfig = Import-CommandConfiguration $_.FullName 
    $commandConfig.Parameters += $globalFlagsParameters

    if ($psobjectofCresendoCommandConfig.AdditionalCrescendoBuilders -contains "StartAndEndFlags") { $commandConfig.Parameters += $StartAndEndFlagsParameters }
    if ($psobjectofCresendoCommandConfig.AdditionalCrescendoBuilders -contains "APIPaging") { $commandConfig.Parameters += $APIPagingParameters }


    Export-CrescendoCommand -command $commandConfig -fileName "$CrescendoBuildersCompletePath/CrescendoComplete_$($_.Name)" -Force
}

Export-CrescendoModule -ConfigurationFile @((Get-ChildItem $CrescendoBuildersCompletePath).fullname) -ModuleName "$moduleFolder/psFilesCli.psm1" -Force

