
$Scripthome = $PSScriptRoot

$moduleFolder = "$PSScriptRoot/psFilesCli"

$CrecendoBuildersCompletePath = "$Scripthome/CrecendoCommandConfigsComplete"
$CrecendoBuildersPath = "$Scripthome/CrescendoCommandConfigs"
$CrescendoBuildersPath = "$Scripthome/CrescendoBuilders"

. "$Scripthome\Build_Functions.ps1"

$globalFlagsParameters = (Get-Content "$CrescendoBuildersPath/GlobalFlags.json" | ConvertFrom-Json).commands.parameters
$StartAndEndFlagsParameters = (Get-Content "$CrescendoBuildersPath/StartAndEndFlags.json" | ConvertFrom-Json).commands.parameters
$APIPagingParameters = (Get-Content "$CrescendoBuildersPath/APIPaging.json" | ConvertFrom-Json).commands.parameters

$CrecendoBuilderFiles = Get-ChildItem $CrecendoBuildersPath -Recurse -File


Get-ChildItem $CrecendoBuildersCompletePath | Where-Object { $_.FullName -match 'CrecendoCommandConfigsComplete(/|\\)CrecendoComplete_' } | Remove-Item -Force

$CrecendoBuilderFiles | ForEach-Object {
    $psobjectofCresendoCommandConfig = (Get-Content $_.FullName | ConvertFrom-Json)

    $commandConfig = Import-CommandConfiguration $_.FullName 
    $commandConfig.Parameters += $globalFlagsParameters

    if ($psobjectofCresendoCommandConfig.AdditionalCrescendoBuilders -contains "StartAndEndFlags") { $commandConfig.Parameters += $StartAndEndFlagsParameters }
    if ($psobjectofCresendoCommandConfig.AdditionalCrescendoBuilders -contains "APIPaging") { $commandConfig.Parameters += $APIPagingParameters }


    Export-CrescendoCommand -command $commandConfig -fileName "$CrecendoBuildersCompletePath/CrecendoComplete_$($_.Name)" -Force
}

Export-CrescendoModule -ConfigurationFile @((Get-ChildItem $CrecendoBuildersCompletePath).fullname) -ModuleName "$moduleFolder/psFilesCli.psm1" -Force

