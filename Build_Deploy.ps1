
$Scripthome = $PSScriptRoot

$moduleFolder = "$Scripthome/psFilesCli"

$CrescendoBuildersCompletePath = "$Scripthome/CrescendoCommandConfigsComplete"
$CrescendoCommandsPath = "$Scripthome/CrescendoCommandConfigs"
$CrescendoBuildersPath = "$Scripthome/CrescendoBuilders"


$globalFlagsParameters = (Get-Content "$CrescendoBuildersPath/GlobalFlags.json" | ConvertFrom-Json).commands.parameters
$StartAndEndFlagsParameters = (Get-Content "$CrescendoBuildersPath/StartAndEndFlags.json" | ConvertFrom-Json).commands.parameters
$APIPagingParameters = (Get-Content "$CrescendoBuildersPath/APIPaging.json" | ConvertFrom-Json).commands.parameters
$ObjectFormatingParameters = (Get-Content "$CrescendoBuildersPath/ObjectFormating.json" | ConvertFrom-Json).commands.parameters
$FilesCLIChildItem_AutoComplete_string = "[ArgumentCompleter ({" + (Get-Content "$CrescendoBuildersPath/FilesCLIChildItem_AutoComplete.ps1" -raw) + "})]"

$CrescendoBuilderFiles = Get-ChildItem $CrescendoCommandsPath -Recurse -File

new-item -ItemType Directory -Path $CrescendoBuildersCompletePath -ErrorAction SilentlyContinue
Get-ChildItem $CrescendoBuildersCompletePath | Where-Object { $_.FullName -match 'CrescendoCommandConfigsComplete(/|\\)CrescendoComplete_' } | Remove-Item -Force

foreach ($builderfile in $CrescendoBuilderFiles)  {
    write-host "$($builderfile.fullname)"
    $psobjectofCresendoCommandConfig = (Get-Content $builderfile.FullName | ConvertFrom-Json)

    $commandConfig = Import-CommandConfiguration $builderfile.FullName 
    $commandConfig.Parameters += $globalFlagsParameters

    $skipObjectFormating=@("Set-FilesCliConfig_Crecendo.json","Reset-FilesCliConfig_Crecendo.json","Get-FilesCliConfig_Crecendo.json")
    if ($builderfile.name -notin $skipObjectFormating) { $commandConfig.Parameters += $ObjectFormatingParameters }

    if ($psobjectofCresendoCommandConfig.AdditionalCrescendoBuilders -contains "StartAndEndFlags") { $commandConfig.Parameters += $StartAndEndFlagsParameters }
    if ($psobjectofCresendoCommandConfig.AdditionalCrescendoBuilders -contains "APIPaging") { $commandConfig.Parameters += $APIPagingParameters }

    $commandConfig.parameters | ForEach-Object {

        if ($_.AdditionalParameterAttributes) {
            $_.AdditionalParameterAttributes = $_.AdditionalParameterAttributes | ForEach-Object {
                if ($_ -eq '---CrecendoBuilder-ReplaceWith-FilesCLIChildItem_AutoComplete_string---') {
                    write-host "replace"
                    $_.replace("---CrecendoBuilder-ReplaceWith-FilesCLIChildItem_AutoComplete_string---", $FilesCLIChildItem_AutoComplete_string)
                } else {
                    $_
                }
            }
        }
    }

    Export-CrescendoCommand -command $commandConfig -fileName "$CrescendoBuildersCompletePath/CrescendoComplete_$($builderfile.Name)" -Force
}

Export-CrescendoModule -ConfigurationFile @((Get-ChildItem $CrescendoBuildersCompletePath).fullname) -ModuleName "$moduleFolder/psFilesCli.psm1" -Force

