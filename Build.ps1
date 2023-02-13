
$Scripthome = $PSScriptRoot

$moduleFolder = Split-Path $Scripthome

$CrecendoBuildersCompletePath = "$Scripthome/CrecendoCommandConfigsComplete"
$CrecendoBuildersPath = "$Scripthome/CrescendoCommandConfigs"
$CrescendoBuildersPath = "$Scripthome/CrescendoBuilders"

function privFilesCli_FieldsArrayToCommaSeparated {
    param([string[]]$v) 
    if("AllFields" -in $v){
        #All Fields will be shown
    }else{
    "--fields=" + ($v -join ',')
    }
}

function privFilesCli_DateTimeToGMTFilesFormat {
    param([datetime]$v) 
    Get-Date -AsUTC $v -UFormat %Y-%m-%dT%H:%M:%SZ
}

function privFilesCli_CommonJSONtoPSobjectHandler {
    PROCESS { 
        if ($args[0]) {
            try {$args[0] | ConvertFrom-Json -ea stop
            } catch {
                #if for some reason the output dosn't come back as a json try to convert it
                $args[0] | ConvertTo-Json | ConvertFrom-Json
            }
        } 
    } 
    END { 
        Pop-CrescendoNativeError -EmitAsError
    }
}

function privFilesCli_UserOutPutHandler {
    PROCESS {
        if ($args[0]) {
            $args[0] | ConvertFrom-Json | ForEach-Object {
                if ($_.admin_ids) {$_.admin_ids = $_.admin_ids.split(',')}
                if ($_.usernames) {$_.usernames = $_.usernames.split(',')}
                if ($_.user_ids) {$_.user_ids = $_.user_ids.split(',')}
                $_ 
            }
        } 
    } 
    END { Pop-CrescendoNativeError }
    
}

function privFilesCli_BehaviorValue {
    param($v) 
    if ($v -is [pscustomobject]) {
        Write-Verbose "privFilesCli_BehaviorValue pscustomobject to json"
        $formated=$v | ConvertTo-Json -Compress
    } elseif ($v -is [hashtable]) {
        Write-Verbose "privFilesCli_BehaviorValue hashtable to json"
        $formated=$v | ConvertTo-Json -Compress
    } else {
        Write-Verbose "privFilesCli_BehaviorValue else passthru"
        $formated=$v
    }

    "--value=" + ($formated)
}

$globalFlagsParameters = (Get-Content "$CrescendoBuildersPath/GlobalFlags.json" | ConvertFrom-Json).commands.parameters
$StartAndEndFlagsParameters = (Get-Content "$CrescendoBuildersPath/StartAndEndFlags.json" | ConvertFrom-Json).commands.parameters

$CrecendoBuilderFiles = Get-ChildItem $CrecendoBuildersPath -Recurse -File

#Get-ChildItem $CrecendoBuildersCompletePath |Remove-Item 

$CrecendoBuilderFiles | ForEach-Object {
    $addStartAndEndFlags = $null

    $psobjectofCresendoCommandConfig = (Get-Content $_.FullName | ConvertFrom-Json)

    if ($psobjectofCresendoCommandConfig.AdditionalCrescendoBuilders -contains "StartAndEndFlags") {$addStartAndEndFlags = $true}


    $commandConfig = Import-CommandConfiguration $_.FullName 
    $commandConfig.Parameters += $globalFlagsParameters

    if ($addStartAndEndFlags) {$commandConfig.Parameters += $StartAndEndFlagsParameters}


    Export-CrescendoCommand -command $commandConfig -fileName "$CrecendoBuildersCompletePath/$($_.Name)" -Force
}

Export-CrescendoModule -ConfigurationFile @((Get-ChildItem $CrecendoBuildersCompletePath).fullname) -ModuleName "$moduleFolder/psFilesCli.psm1" -Force
