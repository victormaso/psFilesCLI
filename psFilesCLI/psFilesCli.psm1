# Module created by Microsoft.PowerShell.Crescendo
# Version: 1.1.0
# Schema: https://aka.ms/PowerShell/Crescendo/Schemas/2022-06
# Generated at: 05/23/2024 10:52:07
class PowerShellCustomFunctionAttribute : System.Attribute {
    [bool]$RequiresElevation
    [string]$Source
    PowerShellCustomFunctionAttribute() { $this.RequiresElevation = $false; $this.Source = "Microsoft.PowerShell.Crescendo" }
    PowerShellCustomFunctionAttribute([bool]$rElevation) {
        $this.RequiresElevation = $rElevation
        $this.Source = "Microsoft.PowerShell.Crescendo"
    }
}

# Returns available errors
# Assumes that we are being called from within a script cmdlet when EmitAsError is used.
function Pop-CrescendoNativeError {
param ([switch]$EmitAsError)
    while ($__CrescendoNativeErrorQueue.Count -gt 0) {
        if ($EmitAsError) {
            $msg = $__CrescendoNativeErrorQueue.Dequeue()
            $er = [System.Management.Automation.ErrorRecord]::new([system.invalidoperationexception]::new($msg), $PSCmdlet.Name, "InvalidOperation", $msg)
            $PSCmdlet.WriteError($er)
        }
        else {
            $__CrescendoNativeErrorQueue.Dequeue()
        }
    }
}
# this is purposefully a filter rather than a function for streaming errors
filter Push-CrescendoNativeError {
    if ($_ -is [System.Management.Automation.ErrorRecord]) {
        $__CrescendoNativeErrorQueue.Enqueue($_)
    }
    else {
        $_
    }
}

function Copy-FilesCliItem
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Alias('path')]
[Parameter(Position=0,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=0,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$Source,
[Parameter(Position=1,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=1,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$Destination,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$Block,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$NoProgress,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$Eventlog,
[Parameter(Position=2,ParameterSetName='Default')]
[Parameter(Position=2,ParameterSetName='GlobalFlags')]
[string[]]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Source = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Destination = @{
               OriginalName = '--destination'
               OriginalPosition = '1'
               Position = '1'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Block = @{
               OriginalName = '--block'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         NoProgress = @{
               OriginalName = '--no-progress'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Eventlog = @{
               OriginalName = '--event-log'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '2'
               Position = '2'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'files'
    $__commandArgs += 'copy'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
starts a job to copy a file within the site

.PARAMETER Source
Specify the path to files.com virtual directory/file to copy


.PARAMETER Destination
Copy destination path.


.PARAMETER Block
Wait on response for async move with final status.


.PARAMETER NoProgress
Don't display progress bars when using block flag


.PARAMETER Eventlog
Output full event log for move when used with block flag


.PARAMETER fields
Fields to include in output


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.EXAMPLE
PS> Get-FilesCliChildItem -path /demo |Where-Object {$_.display_name -like "*.csv"} | New-FilesCliDownload -localpath C:\temp\localFilesDemoFolder

Lists out all objects in files.com /demo directory. Filters for files that are like '*csv' then downloads them


.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliApiKeysFind
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Alias('id')]
[Parameter(Mandatory=$true)]
[string]$ApiID,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         ApiID = @{
               OriginalName = '--id='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'api-keys'
    $__commandArgs += 'find'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
lists the Permissions in the site

.PARAMETER ApiID
Will get information from this api id


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliApiKeysList
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Alias('id')]
[Parameter(ParameterSetName='userid')]
[string]$UserID,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         UserID = @{
               OriginalName = '--user-id='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'api-keys'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
lists the Permissions in the site

.PARAMETER UserID
If provided, will scope to this user


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliApiRequestLogs
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="200")]
[int]$PerPage = "200",
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="50")]
[int]$MaxPages = "50"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         PerPage = @{
               OriginalName = '--per-page='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         MaxPages = @{
               OriginalName = '--max-pages='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'api-request-logs'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
shows Api request logs

.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password


.PARAMETER PerPage
Number of records to show per page.  (Max: 10,000, 1,000 or less is recommended). Note there is no warning if there were more pages available. Set higher if you need to return more data.


.PARAMETER MaxPages
When per-page is set max-pages limits the total number of pages requested. Note there is no warning if there were more pages available. Set higher if you need to return more data.



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliAutomationLogs
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string[]]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="200")]
[int]$PerPage = "200",
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="50")]
[int]$MaxPages = "50"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         fields = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         PerPage = @{
               OriginalName = '--per-page='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         MaxPages = @{
               OriginalName = '--max-pages='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'automation-runs'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
Automation Run Logs

.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password


.PARAMETER PerPage
Number of records to show per page.  (Max: 10,000, 1,000 or less is recommended). Note there is no warning if there were more pages available. Set higher if you need to return more data.


.PARAMETER MaxPages
When per-page is set max-pages limits the total number of pages requested. Note there is no warning if there were more pages available. Set higher if you need to return more data.



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliAutomationRunsFind
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Alias('id')]
[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[int]$automationRunId,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string[]]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         automationRunId = @{
               OriginalName = '--id='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'automation-runs'
    $__commandArgs += 'find'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
detail on an automation run

.PARAMETER automationRunId
Automation Run ID


.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliAutomationRunsList
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Alias('automation_id')]
[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[int]$automationid,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         automationid = @{
               OriginalName = '--automation-id='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'automation-runs'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
get the runs for an automation

.PARAMETER automationid
ID of the associated Automation


.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliAutomationsList
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'automations'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
lists automations

.PARAMETER fields
comma separated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliBehaviors
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName='Default')]
[Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName='GlobalFlags')]
[string]$behavior,
[ValidateSet('AllFields','attachment_delete','attachment_file','attachment_url','behavior','description','id','name','path','value')]
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="attachment_delete,attachment_file,attachment_url,behavior,description,id,name,path,value")]
[string[]]$fields = "attachment_delete,attachment_file,attachment_url,behavior,description,id,name,path,value",
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         behavior = @{
               OriginalName = '--behavior='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'behaviors'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
List behaviors in the site

.PARAMETER behavior
Specify behavior type


.PARAMETER fields
Fields to include in output


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliBehaviorsByPath
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$path,
[ValidateSet('AllFields','attachment_delete','attachment_file','attachment_url','behavior','description','id','name','path','value')]
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="attachment_delete,attachment_file,attachment_url,behavior,description,id,name,path,value")]
[string[]]$fields = "attachment_delete,attachment_file,attachment_url,behavior,description,id,name,path,value",
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$recursive,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         path = @{
               OriginalName = '--path='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         recursive = @{
               OriginalName = '--recursive=True'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'behaviors'
    $__commandArgs += 'list-for'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
list behaviours by path

.PARAMETER path
Specify the folder path


.PARAMETER fields
Fields to include in output


.PARAMETER recursive
Show behaviors above this path?


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliChildItem
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$path,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$Recursive,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$OnlyFolders,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[int]$ConcurrentDirectoryListLimit,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$filter,
[ValidateSet('AllFields','action','created_at','crc32','display_name','download_uri','is_locked','length','md5','mime_type','mkdir_parents','mtime','part','parts','path','permissions','preview','preview_id','priority_color','provided_mtime','ref','region','restart','size','structure','subfolders_locked?','type','with_rename')]
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="display_name,path,size,permissions,type")]
[string[]]$fields = "display_name,path,size,permissions,type",
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$withpreviews,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         path = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Recursive = @{
               OriginalName = '--recursive=True'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         OnlyFolders = @{
               OriginalName = '--only-folders=True'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         ConcurrentDirectoryListLimit = @{
               OriginalName = '--concurrent-directory-list-limit='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         filter = @{
               OriginalName = '--filter='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         withpreviews = @{
               OriginalName = '--with-previews=True'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--with-previews=False'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'folders'
    $__commandArgs += 'list-for'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
lists the folders and files within a folder

.PARAMETER path
Specify the path


.PARAMETER Recursive
list folders/files recursively.


.PARAMETER OnlyFolders
only return folders and not files


.PARAMETER ConcurrentDirectoryListLimit
Limit the concurrent directory listings of remote directories. (default 75)


.PARAMETER filter
If specified, will filter folders/files list by this string.  Wildcards of * and '?' are acceptable here.


.PARAMETER fields
Fields to include in output


.PARAMETER withpreviews
Include file previews?


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliConfig
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'config'
    $__commandArgs += 'show'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
show the config

.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliEmailIncomingMessages
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="200")]
[int]$PerPage = "200",
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="50")]
[int]$MaxPages = "50"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         PerPage = @{
               OriginalName = '--per-page='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         MaxPages = @{
               OriginalName = '--max-pages='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'email-incoming-messages'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
shows Api request logs

.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password


.PARAMETER PerPage
Number of records to show per page.  (Max: 10,000, 1,000 or less is recommended). Note there is no warning if there were more pages available. Set higher if you need to return more data.


.PARAMETER MaxPages
When per-page is set max-pages limits the total number of pages requested. Note there is no warning if there were more pages available. Set higher if you need to return more data.



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliEmailLogs
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="200")]
[int]$PerPage = "200",
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="50")]
[int]$MaxPages = "50"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         PerPage = @{
               OriginalName = '--per-page='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         MaxPages = @{
               OriginalName = '--max-pages='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'email-logs'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
shows Email logs

.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password


.PARAMETER PerPage
Number of records to show per page.  (Max: 10,000, 1,000 or less is recommended). Note there is no warning if there were more pages available. Set higher if you need to return more data.


.PARAMETER MaxPages
When per-page is set max-pages limits the total number of pages requested. Note there is no warning if there were more pages available. Set higher if you need to return more data.



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliExternalEventsList
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'external-events'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
get the external log from files.com

.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliFileMigrationLogs
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="200")]
[int]$PerPage = "200",
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="50")]
[int]$MaxPages = "50"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         PerPage = @{
               OriginalName = '--per-page='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         MaxPages = @{
               OriginalName = '--max-pages='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'file-migration-logs'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
shows Api request logs

.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password


.PARAMETER PerPage
Number of records to show per page.  (Max: 10,000, 1,000 or less is recommended). Note there is no warning if there were more pages available. Set higher if you need to return more data.


.PARAMETER MaxPages
When per-page is set max-pages limits the total number of pages requested. Note there is no warning if there were more pages available. Set higher if you need to return more data.



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliFtpActionLogs
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="200")]
[int]$PerPage = "200",
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="50")]
[int]$MaxPages = "50"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         PerPage = @{
               OriginalName = '--per-page='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         MaxPages = @{
               OriginalName = '--max-pages='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'ftp-action-logs'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
shows ftp action logs

.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password


.PARAMETER PerPage
Number of records to show per page.  (Max: 10,000, 1,000 or less is recommended). Note there is no warning if there were more pages available. Set higher if you need to return more data.


.PARAMETER MaxPages
When per-page is set max-pages limits the total number of pages requested. Note there is no warning if there were more pages available. Set higher if you need to return more data.



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliGroupsList
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$ids,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         ids = @{
               OriginalName = '--ids='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_UserOutPutHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'groups'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
lists groups in files.com

.PARAMETER ids
Comma-separated list of group ids to include in results.


.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliGroupMembers
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Alias('id')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[int]$groupid,
[ValidateSet('AllFields','id','group_name','admin','group_id','user_id','usernames')]
[Parameter(Position=2,ParameterSetName='Default')]
[Parameter(Position=2,ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="group_name,user_id,admin")]
[string[]]$fields = "group_name,user_id,admin",
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         groupid = @{
               OriginalName = '--group-id='
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '2'
               Position = '2'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_UserOutPutHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'group-users'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
shows the UserID members of the group

.PARAMETER groupid
Group ID.  If provided, will return group_users of this group


.PARAMETER fields
Fields to include in output


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliUserGroupMembership
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Alias('id')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[int]$userid,
[ValidateSet('AllFields','id','group_name','admin','group_id','user_id','usernames')]
[Parameter(Position=2,ParameterSetName='Default')]
[Parameter(Position=2,ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="id,group_name,admin,group_id")]
[string[]]$fields = "id,group_name,admin,group_id",
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         userid = @{
               OriginalName = '--user-id='
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '2'
               Position = '2'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_UserOutPutHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'group-users'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
shows a users group membership

.PARAMETER userid
User ID.  If provided, will return group_users of this user.


.PARAMETER fields
Fields to include in output


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliHistoriesList
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$cursor,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$display,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$filter,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[datetime]$endat,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[datetime]$startat
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         cursor = @{
               OriginalName = '--cursor='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         display = @{
               OriginalName = '--display='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         filter = @{
               OriginalName = '--filter='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         endat = @{
               OriginalName = '--end-at'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'datetime'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_DateTimeToGMTFilesFormat'
               ArgumentTransformType = 'Function'
               }
         startat = @{
               OriginalName = '--start-at'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'datetime'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_DateTimeToGMTFilesFormat'
               ArgumentTransformType = 'Function'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'histories'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
shows site history

.PARAMETER cursor
Used for pagination.  Send a cursor value to resume an existing list from the point at which you left off.  Get a cursor from an existing list via either the X-Files-Cursor-Next header or the X-Files-Cursor-Prev header.


.PARAMETER display
Display format. Leave blank or set to full or `parent`.


.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER filter
If specified, will filter folders/files list by this string.  Wildcards of * and '?' are acceptable here.


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password


.PARAMETER endat
Leave blank or set to a date/time to filter later entries. use powershell datetime


.PARAMETER startat
Leave blank or set to a date/time to filter earlier entries. use powershell datetime



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliHistoriesListFile
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$path,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$cursor,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$display,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$filter,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[datetime]$endat,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[datetime]$startat
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         path = @{
               OriginalName = '--path='
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         cursor = @{
               OriginalName = '--cursor='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         display = @{
               OriginalName = '--display='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         filter = @{
               OriginalName = '--filter='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         endat = @{
               OriginalName = '--end-at'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'datetime'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_DateTimeToGMTFilesFormat'
               ArgumentTransformType = 'Function'
               }
         startat = @{
               OriginalName = '--start-at'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'datetime'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_DateTimeToGMTFilesFormat'
               ArgumentTransformType = 'Function'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'histories'
    $__commandArgs += 'list-for-file'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
shows history on a file

.PARAMETER path
Specify the path


.PARAMETER cursor
Used for pagination.  Send a cursor value to resume an existing list from the point at which you left off.  Get a cursor from an existing list via either the X-Files-Cursor-Next header or the X-Files-Cursor-Prev header.


.PARAMETER display
Display format. Leave blank or set to full or `parent`.


.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER filter
If specified, will filter folders/files list by this string.  Wildcards of * and '?' are acceptable here.


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password


.PARAMETER endat
Leave blank or set to a date/time to filter later entries. use powershell datetime


.PARAMETER startat
Leave blank or set to a date/time to filter earlier entries. use powershell datetime



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliHistoriesListFolder
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$path,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$cursor,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$display,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$filter,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[datetime]$endat,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[datetime]$startat
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         path = @{
               OriginalName = '--path='
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         cursor = @{
               OriginalName = '--cursor='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         display = @{
               OriginalName = '--display='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         filter = @{
               OriginalName = '--filter='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         endat = @{
               OriginalName = '--end-at'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'datetime'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_DateTimeToGMTFilesFormat'
               ArgumentTransformType = 'Function'
               }
         startat = @{
               OriginalName = '--start-at'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'datetime'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_DateTimeToGMTFilesFormat'
               ArgumentTransformType = 'Function'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'histories'
    $__commandArgs += 'list-for-folder'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
shows history on a folder

.PARAMETER path
Specify the path


.PARAMETER cursor
Used for pagination.  Send a cursor value to resume an existing list from the point at which you left off.  Get a cursor from an existing list via either the X-Files-Cursor-Next header or the X-Files-Cursor-Prev header.


.PARAMETER display
Leave blank or set to a date/time to filter later entries. - format: 2006-01-02T15:04:05Z07:00


.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER filter
If specified, will filter folders/files list by this string.  Wildcards of * and '?' are acceptable here.


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password


.PARAMETER endat
Leave blank or set to a date/time to filter later entries. use powershell datetime


.PARAMETER startat
Leave blank or set to a date/time to filter earlier entries. use powershell datetime



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliHistoriesListLogins
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$cursor,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$display,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$filter,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[datetime]$endat,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[datetime]$startat
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         cursor = @{
               OriginalName = '--cursor='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         display = @{
               OriginalName = '--display='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         filter = @{
               OriginalName = '--filter='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         endat = @{
               OriginalName = '--end-at'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'datetime'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_DateTimeToGMTFilesFormat'
               ArgumentTransformType = 'Function'
               }
         startat = @{
               OriginalName = '--start-at'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'datetime'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_DateTimeToGMTFilesFormat'
               ArgumentTransformType = 'Function'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'histories'
    $__commandArgs += 'list-logins'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
shows site logon history

.PARAMETER cursor
Used for pagination.  Send a cursor value to resume an existing list from the point at which you left off.  Get a cursor from an existing list via either the X-Files-Cursor-Next header or the X-Files-Cursor-Prev header.


.PARAMETER display
Display format. Leave blank or set to full or `parent`.


.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER filter
If specified, will filter folders/files list by this string.  Wildcards of * and '?' are acceptable here.


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password


.PARAMETER endat
Leave blank or set to a date/time to filter later entries. use powershell datetime


.PARAMETER startat
Leave blank or set to a date/time to filter earlier entries. use powershell datetime



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliHistoryExport
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$HistoryExportID,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string[]]$Fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         HistoryExportID = @{
               OriginalName = '--id='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Fields = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'history-exports'
    $__commandArgs += 'find'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
Show History Export

.PARAMETER HistoryExportID
History Export ID


.PARAMETER Fields
Fields to include in output


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliHistoryExportResults
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$HistoryExportID,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string[]]$Fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         HistoryExportID = @{
               OriginalName = '--history-export-id='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Fields = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'history-export-results'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--per-page=10000'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
List History Export Results

.PARAMETER HistoryExportID
ID of the associated history export.


.PARAMETER Fields
Fields to include in output


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliIPAddressesList
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_UserOutPutHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'ip-addresses'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
lists IP addresses

.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliItem
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$path,
[ValidateSet('AllFields','action','created_at','crc32','display_name','download_uri','is_locked','length','md5','mime_type','mkdir_parents','mtime','part','parts','path','permissions','preview','preview_id','priority_color','provided_mtime','ref','region','restart','size','structure','subfolders_locked?','type','with_rename')]
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="display_name,created_at,mtime,path,permissions,type,size")]
[string[]]$fields = "display_name,created_at,mtime,path,permissions,type,size",
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$withpreviews,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         path = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         withpreviews = @{
               OriginalName = '--with-previews=True'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--with-previews=False'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'files'
    $__commandArgs += 'find'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
get detail on a folder or file

.PARAMETER path
Specify the path


.PARAMETER fields
Fields to include in output


.PARAMETER withpreviews
Include file previews?


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliNotifications
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName='Default')]
[Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName='GlobalFlags')]
[string]$path,
[Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName='Default')]
[Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName='GlobalFlags')]
[string]$UserID,
[Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName='Default')]
[Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName='GlobalFlags')]
[string]$GroupID,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$ExcludeAncestors,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         path = @{
               OriginalName = '--path='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         UserID = @{
               OriginalName = '--user-id='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         GroupID = @{
               OriginalName = '--group-id='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         ExcludeAncestors = @{
               OriginalName = '--include-ancestors=false'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'notifications'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
List behaviors in the site

.PARAMETER path
Specify the folder path


.PARAMETER UserID
Specify specific User ID


.PARAMETER GroupID
Specify specific GroupID


.PARAMETER ExcludeAncestors
Does not include notifications for any parent paths.


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliPermissionList
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='userid')]
[Parameter(ParameterSetName='groupid')]
[switch]$DoNotRecurseGroups,
[Parameter(ParameterSetName='path')]
[string]$Path,
[Parameter(ParameterSetName='userid')]
[string]$UserID,
[Parameter(ParameterSetName='groupid')]
[string]$GroupID,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[Parameter(ParameterSetName='path')]
[Parameter(ParameterSetName='userid')]
[Parameter(ParameterSetName='groupid')]
[string]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         DoNotRecurseGroups = @{
               OriginalName = '--include-groups=False'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Path = @{
               OriginalName = '--path='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         UserID = @{
               OriginalName = '--user-id='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         GroupID = @{
               OriginalName = '--group-id='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'permissions'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
lists the Permissions in the site

.PARAMETER DoNotRecurseGroups
If searching by user or group, do not include user's permissions that are inherited from its groups


.PARAMETER Path
Permission path.  If provided, will scope all permissions(including upward) to this path.


.PARAMETER UserID
If provided, will scope permissions to this user.


.PARAMETER GroupID
If provided, will scope permissions to this group.


.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliRemoteServerById
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[int]$id,
[ValidateSet('AllFields','authentication_method','auth_account_name','auth_setup_link','auth_status','aws_access_key','aws_secret_key','azure_blob_storage_access_key','azure_blob_storage_account','azure_blob_storage_container','azure_blob_storage_sas_token','azure_files_storage_access_key','azure_files_storage_account','azure_files_storage_sas_token','azure_files_storage_share_name','backblaze_b2_application_key','backblaze_b2_bucket','backblaze_b2_key_id','backblaze_b2_s3_endpoint','disabled','enable_dedicated_ips','filebase_access_key','filebase_bucket','filebase_secret_key','files_agent_api_token','files_agent_permission_set','files_agent_root','google_cloud_storage_bucket','google_cloud_storage_credentials_json','google_cloud_storage_project_id','hostname','id','max_connections','name','one_drive_account_type','password','pinned_region','pin_to_site_region','port','private_key','private_key_passphrase','rackspace_api_key','rackspace_container','rackspace_region','rackspace_username','remote_home_path','reset_authentication','s3_bucket','s3_compatible_access_key','s3_compatible_bucket','s3_compatible_endpoint','s3_compatible_region','s3_compatible_secret_key','s3_region','server_certificate','server_host_key','server_type','ssl','ssl_certificate','username','wasabi_access_key','wasabi_bucket','wasabi_region','wasabi_secret_key')]
[Parameter(Position=2,ParameterSetName='Default')]
[Parameter(Position=2,ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="AllFields")]
[string[]]$fields = "AllFields",
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         id = @{
               OriginalName = '--id='
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '2'
               Position = '2'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'remote-servers'
    $__commandArgs += 'find'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
Remote-server detail by ID

.PARAMETER id
Remote-Server ID


.PARAMETER fields
Fields to include in output


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliRemoteServersList
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[ValidateSet('AllFields','authentication_method','auth_account_name','auth_setup_link','auth_status','aws_access_key','aws_secret_key','azure_blob_storage_access_key','azure_blob_storage_account','azure_blob_storage_container','azure_blob_storage_sas_token','azure_files_storage_access_key','azure_files_storage_account','azure_files_storage_sas_token','azure_files_storage_share_name','backblaze_b2_application_key','backblaze_b2_bucket','backblaze_b2_key_id','backblaze_b2_s3_endpoint','disabled','enable_dedicated_ips','filebase_access_key','filebase_bucket','filebase_secret_key','files_agent_api_token','files_agent_permission_set','files_agent_root','google_cloud_storage_bucket','google_cloud_storage_credentials_json','google_cloud_storage_project_id','hostname','id','max_connections','name','one_drive_account_type','password','pinned_region','pin_to_site_region','port','private_key','private_key_passphrase','rackspace_api_key','rackspace_container','rackspace_region','rackspace_username','remote_home_path','reset_authentication','s3_bucket','s3_compatible_access_key','s3_compatible_bucket','s3_compatible_endpoint','s3_compatible_region','s3_compatible_secret_key','s3_region','server_certificate','server_host_key','server_type','ssl','ssl_certificate','username','wasabi_access_key','wasabi_bucket','wasabi_region','wasabi_secret_key')]
[Parameter(Position=2,ParameterSetName='Default')]
[Parameter(Position=2,ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="id,name,server_type,remote_home_path,disabled,hostname,username,max_connections,authentication_method,enable_dedicated_ips,pin_to_site_region,server_host_key,port,server_certificate")]
[string[]]$fields = "id,name,server_type,remote_home_path,disabled,hostname,username,max_connections,authentication_method,enable_dedicated_ips,pin_to_site_region,server_host_key,port,server_certificate",
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         fields = @{
               OriginalName = ''
               OriginalPosition = '2'
               Position = '2'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'remote-servers'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
lists the remote-servers in the site

.PARAMETER fields
Fields to include in output


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliSettingsChanges
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[ValidateSet('AllFields','changes','created_at','user_id','user_is_files_support','username')]
[Parameter(Position=2,ParameterSetName='Default')]
[Parameter(Position=2,ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="AllFields")]
[string[]]$fields = "AllFields",
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         fields = @{
               OriginalName = ''
               OriginalPosition = '2'
               Position = '2'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'settings-changes'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
lists the settings-changes in the site

.PARAMETER fields
Fields to include in output


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliSftpActionLogs
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="200")]
[int]$PerPage = "200",
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="50")]
[int]$MaxPages = "50"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         PerPage = @{
               OriginalName = '--per-page='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         MaxPages = @{
               OriginalName = '--max-pages='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'sftp-action-logs'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
shows sftp action logs

.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password


.PARAMETER PerPage
Number of records to show per page.  (Max: 10,000, 1,000 or less is recommended). Note there is no warning if there were more pages available. Set higher if you need to return more data.


.PARAMETER MaxPages
When per-page is set max-pages limits the total number of pages requested. Note there is no warning if there were more pages available. Set higher if you need to return more data.



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliSyncLogs
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="200")]
[int]$PerPage = "200",
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="50")]
[int]$MaxPages = "50"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         PerPage = @{
               OriginalName = '--per-page='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         MaxPages = @{
               OriginalName = '--max-pages='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'sync-logs'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
shows site logon history

.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password


.PARAMETER PerPage
Number of records to show per page.  (Max: 10,000, 1,000 or less is recommended). Note there is no warning if there were more pages available. Set higher if you need to return more data.


.PARAMETER MaxPages
When per-page is set max-pages limits the total number of pages requested. Note there is no warning if there were more pages available. Set higher if you need to return more data.



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliUsageDailySnapshots
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'usage-daily-snapshots'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
lists the usage-daily-snapshots in the site

.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliUser
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Alias('id')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[int]$userid,
[ValidateSet('AllFields','active_2fa','admin_group_ids','allowed_ips','announcements_read','api_keys_count','attachments_permission','authenticate_until','authentication_method','avatar_delete','avatar_file','avatar_url','billing_permission','bypass_inactive_disable','bypass_site_allowed_ips','change_password','change_password_confirmation','company','created_at','dav_permission','days_remaining_until_password_expire','disabled','email','externally_managed','first_login_at','ftp_permission','grant_permission','group_id','group_ids','header_text','id','imported_password_hash','language','last_active_at','last_api_use_at','last_dav_login_at','last_desktop_login_at','last_ftp_login_at','last_login_at','last_protocol_cipher','last_restapi_login_at','last_sftp_login_at','last_web_login_at','lockout_expires','name','notes','notification_daily_send_time','office_integration_enabled','password','password_confirmation','password_expire_at','password_expired','password_set_at','password_validity_days','public_keys_count','receive_admin_alerts','require_2fa','require_password_change','restapi_permission','self_managed','sftp_permission','site_admin','skip_welcome_screen','ssl_required','sso_strategy_id','subscribe_to_newsletter','time_zone','type_of_2fa','user_root','username')]
[Parameter(Position=2,ParameterSetName='Default')]
[Parameter(Position=2,ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="id,name,email,disabled,group_ids,last_login_at,last_active_at,password_expired")]
[string[]]$fields = "id,name,email,disabled,group_ids,last_login_at,last_active_at,password_expired",
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         userid = @{
               OriginalName = '--id='
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '2'
               Position = '2'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_UserOutPutHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'users'
    $__commandArgs += 'find'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
user detail by user ID

.PARAMETER userid
User ID


.PARAMETER fields
Fields to include in output


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliUserCipherUses
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Alias('id')]
[Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName='Default')]
[Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName='GlobalFlags')]
[string]$UserID,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         UserID = @{
               OriginalName = '--user-id='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_UserOutPutHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'user-cipher-uses'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
List User Cipher Uses

.PARAMETER UserID
User ID.  Provide a value of 0 to operate the current session's user.


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Get-FilesCliUsersList
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$ids,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         ids = @{
               OriginalName = '--ids='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_UserOutPutHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'users'
    $__commandArgs += 'list'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
lists the users in the site

.PARAMETER ids
Comma-separated list of user ids to include in results.


.PARAMETER fields
comma seperated fields. example   path,type


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Move-FilesCliItem
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Alias('path')]
[Parameter(Position=0,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=0,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$Source,
[Parameter(Position=1,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=1,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$Destination,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$Block,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$Eventlog,
[Parameter(Position=2,ParameterSetName='Default')]
[Parameter(Position=2,ParameterSetName='GlobalFlags')]
[string[]]$fields,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Source = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Destination = @{
               OriginalName = '--destination'
               OriginalPosition = '1'
               Position = '1'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Block = @{
               OriginalName = '--block'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Eventlog = @{
               OriginalName = '--eventlog'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '2'
               Position = '2'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'files'
    $__commandArgs += 'move'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
starts a job to move a file within the site

.PARAMETER Source
Specify the path to files.com virtual directory/file to copy


.PARAMETER Destination
Copy destination path.


.PARAMETER Block
Wait on response for async move with final status.


.PARAMETER Eventlog
Output full event log for move when used with block flag


.PARAMETER fields
Fields to include in output


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.EXAMPLE
PS> Get-FilesCliChildItem -path /demo |Where-Object {$_.display_name -like "*.csv"} | New-FilesCliDownload -localpath C:\temp\localFilesDemoFolder
 testnewline

Lists out all objects in files.com /demo directory. Filters for files that are like '*csv' then downloads them


.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function New-FilesCliBehavior
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(Mandatory=$true,ParameterSetName='Default')]
[Parameter(Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$path,
[Parameter(Mandatory=$true,ParameterSetName='Default')]
[Parameter(Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$behavior,
[Parameter(Mandatory=$true,ParameterSetName='Default')]
[Parameter(Mandatory=$true,ParameterSetName='GlobalFlags')]
[object]$value,
[ValidateSet('AllFields','attachment_delete','attachment_file','attachment_url','behavior','description','id','name','path','value')]
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="attachment_delete,attachment_file,attachment_url,behavior,description,id,name,path,value")]
[string[]]$fields = "attachment_delete,attachment_file,attachment_url,behavior,description,id,name,path,value",
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         path = @{
               OriginalName = '--path='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         behavior = @{
               OriginalName = '--behavior='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         value = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'object'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_BehaviorValue'
               ArgumentTransformType = 'Function'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'behaviors'
    $__commandArgs += 'create'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
Create Behavior on a folder

.PARAMETER path
Specify the folder path


.PARAMETER behavior
Specify behavior type


.PARAMETER value
The value of the folder behavior. Use a PSObject it will be converted to json. Can be a integer, array, or hash depending on the type of folder behavior. See The Behavior Types section for example values for each type of behavior.


.PARAMETER fields
Fields to include in output


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.EXAMPLE
PS> $pubkey = Get-Content 'C:\GPG_pubkey.asc'

 $Behavior = @{
behavior = 'auto_encrypt'
 path = '/Demo/AutoEncryptFolder'
   value = @{
   algorithm = 'PGP/GPG'
   suffix = '.gpg'
   key = $pubkey
   armor = $false
   }
}

 New-FilesCliBehavior @Behavior

Sets a PGP Encrypt behavior on a files.com folder with a public PGP key


.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function New-FilesCliDownload
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Alias('path')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$remotepath,
[Parameter(Position=1,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=1,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$localpath,
[ValidateSet('AllFields','action','attempts','completed_at','crc32','created_at','display_name','download_uri','error','is_locked','length','local_path','md5','mime_type','mkdir_parents','mtime','part','parts','path','permissions','preview','preview_id','priority_color','provided_mtime','ref','region','remote_path','restart','size','size_bytes','started_at','status','structure','subfolders_locked?','transferred_bytes','type','with_rename')]
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="attempts,error,local_path,remote_path,size_bytes,status,started_at,transferred_bytes")]
[string[]]$fields = "attempts,error,local_path,remote_path,size_bytes,status,started_at,transferred_bytes",
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[int]$concurrentconnectionlimit,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[int]$retrycount,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$ignore,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$SendLogsToCloud,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$sync,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$times,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$DownloadFilesAsSingleStream,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         remotepath = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         localpath = @{
               OriginalName = ''
               OriginalPosition = '1'
               Position = '1'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         concurrentconnectionlimit = @{
               OriginalName = '--concurrent-connection-limit='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         retrycount = @{
               OriginalName = '--retry-count='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         ignore = @{
               OriginalName = '--ignore='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         SendLogsToCloud = @{
               OriginalName = '--send-logs-to-cloud'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         sync = @{
               OriginalName = '--sync'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         times = @{
               OriginalName = '--times'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         DownloadFilesAsSingleStream = @{
               OriginalName = '--download-files-as-single-stream'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'download'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
Downloads a file from the site

.PARAMETER remotepath
Specify the path to files.com virtual directory/file to download


.PARAMETER localpath
Specify the path to the local folder to download to


.PARAMETER fields
Fields to include in output


.PARAMETER concurrentconnectionlimit
(default 75)


.PARAMETER retrycount
On transfer failure retry number of times. (default 2)


.PARAMETER ignore
ignore files. See https://git-scm.com/docs/gitignore#_pattern_format


.PARAMETER SendLogsToCloud
Log output as external event


.PARAMETER sync
Only download files with a more recent modified date


.PARAMETER times
Downloaded files to include the original modification time


.PARAMETER DownloadFilesAsSingleStream
Can ensure maximum compatibility with ftp/sftp remote mounts, but reduces download speed


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.EXAMPLE
PS> Get-FilesCliChildItem -path /demo |Where-Object {$_.display_name -like "*.csv"} | New-FilesCliDownload -localpath C:\temp\localFilesDemoFolder

Lists out all objects in files.com /demo directory. Filters for files that are like '*csv' then downloads them


.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function New-FilesCliFolder
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$path,
[ValidateSet('AllFields','action','crc32','created_at','display_name','download_uri','is_locked','length','md5','mime_type','mkdir_parents','mtime','part','parts','path','permissions','preview','preview_id','priority_color','provided_mtime','ref','region','restart','structure','subfolders_locked?','type','with_rename')]
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="display_name,created_at,type")]
[string[]]$fields = "display_name,created_at,type",
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$mkdirparents,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         path = @{
               OriginalName = '--path='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         mkdirparents = @{
               OriginalName = '--mkdir-parents'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'folders'
    $__commandArgs += 'create'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
Creates a folder in the site

.PARAMETER path
Specify the path. Include the name of the folder you want to create.


.PARAMETER fields
Fields to include in output


.PARAMETER mkdirparents
Create parent directories if they do not exist? (default false)


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function New-FilesCliHistoryExport
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[ValidateSet('create', 'read', 'update', 'destroy', 'move', 'login', 'failedlogin', 'copy', 'user_create', 'user_update', 'user_destroy', 'group_create', 'group_update', 'group_destroy', 'permission_create', 'permission_destroy', 'api_key_create', 'api_key_update', 'api_key_destroy')]
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryAction,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryDestination,
[ValidateSet('expired_trial', 'account_overdue', 'locked_out', 'ip_mismatch', 'password_mismatch', 'site_mismatch', 'username_not_found', 'none', 'no_ftp_permission', 'no_web_permission', 'no_directory', 'errno_enoent', 'no_sftp_permission', 'no_dav_permission', 'no_restapi_permission', 'key_mismatch', 'region_mismatch', 'expired_access', 'desktop_ip_mismatch', 'desktop_api_key_not_used_quickly_enough', 'disabled', 'country_mismatch')]
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryFailureType,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryFileID,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryFolder,
[ValidateSet('web', 'ftp', 'robot', 'jsapi', 'webdesktopapi', 'sftp', 'dav', 'desktop', 'restapi', 'scim', 'office', 'mobile', 'as2', 'inbound_email', 'remote')]
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryInterface,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryIP,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryParentID,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryPath,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QuerySrc,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryTargetID,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryTargetName,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryTargetPermission,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryTargetPermissionSet,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryTargetPlatform,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryTargetUserID,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryTargetUsername,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$QueryUserID,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$UserID,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$fields,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$filter,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[datetime]$endat,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[datetime]$startat
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         QueryAction = @{
               OriginalName = '--query-action'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryDestination = @{
               OriginalName = '--query-destination'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryFailureType = @{
               OriginalName = '--query-failure-type'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryFileID = @{
               OriginalName = '--query-file-id'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryFolder = @{
               OriginalName = '--query-folder'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryInterface = @{
               OriginalName = '--query-interface'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryIP = @{
               OriginalName = '--query-ip'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryParentID = @{
               OriginalName = '--query-parent-id'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryPath = @{
               OriginalName = '--query-path'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QuerySrc = @{
               OriginalName = '--query-src'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryTargetID = @{
               OriginalName = '--query-target-id'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryTargetName = @{
               OriginalName = '--query-target-name'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryTargetPermission = @{
               OriginalName = '--query-target-permission'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryTargetPermissionSet = @{
               OriginalName = '--query-target-permission-set'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryTargetPlatform = @{
               OriginalName = '--query-target-platform'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryTargetUserID = @{
               OriginalName = '--query-target-user-id'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryTargetUsername = @{
               OriginalName = '--query-target-username'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         QueryUserID = @{
               OriginalName = '--query-user-id'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         UserID = @{
               OriginalName = '--user-id'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = '--fields='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         filter = @{
               OriginalName = '--filter='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         endat = @{
               OriginalName = '--end-at'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'datetime'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_DateTimeToGMTFilesFormat'
               ArgumentTransformType = 'Function'
               }
         startat = @{
               OriginalName = '--start-at'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'datetime'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_DateTimeToGMTFilesFormat'
               ArgumentTransformType = 'Function'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'history-exports'
    $__commandArgs += 'create'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
Create History Export

.PARAMETER QueryAction
Filter results by this this action type


.PARAMETER QueryDestination
Return results that are file moves with this path as destination.


.PARAMETER QueryFailureType
Filter results by this this action type


.PARAMETER QueryFileID
Return results that are file actions related to the file indicated by this File ID


.PARAMETER QueryFolder
Return results that are file actions related to files or folders inside this folder path.


.PARAMETER QueryInterface
Filter results by this this interface type


.PARAMETER QueryIP
Filter results by this IP address.


.PARAMETER QueryParentID
Return results that are file actions inside the parent folder specified by this folder ID


.PARAMETER QueryPath
Return results that are file actions related to this path.


.PARAMETER QuerySrc
Return results that are file moves originating from this path.


.PARAMETER QueryTargetID
If searching for Histories about specific objects (such as Users, or API Keys), this paremeter restricts results to objects that match this ID.


.PARAMETER QueryTargetName
If searching for Histories about Users, Groups or other objects with names, this parameter restricts results to objects with this name/username.


.PARAMETER QueryTargetPermission
If searching for Histories about Permisisons, this parameter restricts results to permissions of this level.


.PARAMETER QueryTargetPermissionSet
If searching for Histories about API keys, this parameter restricts results to API keys with this permission set.


.PARAMETER QueryTargetPlatform
If searching for Histories about API keys, this parameter restricts results to API keys associated with this platform.


.PARAMETER QueryTargetUserID
If searching for Histories about API keys, this parameter restricts results to API keys created by/for this user ID.


.PARAMETER QueryTargetUsername
If searching for Histories about API keys, this parameter restricts results to API keys created by/for this username.


.PARAMETER QueryUserID
Return results that are actions performed by the user indiciated by this User ID


.PARAMETER UserID
User ID.  Provide a value of 0 to operate the current session's user.


.PARAMETER fields
comma seperated fields


.PARAMETER filter
If specified, will filter folders/files list by this string.  Wildcards of * and '?' are acceptable here.


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password


.PARAMETER endat
Leave blank or set to a date/time to filter later entries. use powershell datetime


.PARAMETER startat
Leave blank or set to a date/time to filter earlier entries. use powershell datetime



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function New-FilesCliSyncPull
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(Position=0,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=0,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$LocalPath,
[Parameter(Position=1,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=1,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$RemotePath,
[Parameter(Mandatory=$true,ParameterSetName='Default')]
[Parameter(Mandatory=$true,ParameterSetName='GlobalFlags')]
[switch]$DryRun,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$Times,
[Parameter(Position=1,ValueFromPipelineByPropertyName=$true,ParameterSetName='Default')]
[Parameter(Position=1,ValueFromPipelineByPropertyName=$true,ParameterSetName='GlobalFlags')]
[string]$OutputFilePath,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[int]$concurrentconnectionlimit,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[int]$retrycount,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$ignore,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$SendLogsToCloud,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$sync,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         LocalPath = @{
               OriginalName = '--local-path='
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         RemotePath = @{
               OriginalName = '--remote-path='
               OriginalPosition = '1'
               Position = '1'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         DryRun = @{
               OriginalName = '--dry-run'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Times = @{
               OriginalName = '--times'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         OutputFilePath = @{
               OriginalName = '--output='
               OriginalPosition = '1'
               Position = '1'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         concurrentconnectionlimit = @{
               OriginalName = '--concurrent-connection-limit='
               OriginalPosition = '2'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         retrycount = @{
               OriginalName = '--retry-count='
               OriginalPosition = '2'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         ignore = @{
               OriginalName = '--ignore='
               OriginalPosition = '2'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         SendLogsToCloud = @{
               OriginalName = '--send-logs-to-cloud'
               OriginalPosition = '2'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         sync = @{
               OriginalName = '--sync'
               OriginalPosition = '2'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'sync'
    $__commandArgs += 'pull'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
sync files

.PARAMETER LocalPath
{local path}


.PARAMETER RemotePath
{remote path}


.PARAMETER DryRun
Index files and compare with destination but don't transfer files.


.PARAMETER Times
Pulled files to include the original modification time


.PARAMETER OutputFilePath
file path to save output


.PARAMETER concurrentconnectionlimit
(default 75)


.PARAMETER retrycount
On transfer failure retry number of times. (default 2)


.PARAMETER ignore
ignore files. See https://git-scm.com/docs/gitignore#_pattern_format


.PARAMETER SendLogsToCloud
Log output as external event


.PARAMETER sync
Only upload files with a more recent modified date


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function New-FilesCliUpload
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Alias('source-path','localpath','FullName')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$path,
[Parameter(Position=1,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=1,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$remotepath,
[ValidateSet('AllFields','action','attempts','completed_at','crc32','created_at','display_name','download_uri','error','is_locked','length','local_path','md5','mime_type','mkdir_parents','mtime','part','parts','path','permissions','preview','preview_id','priority_color','provided_mtime','ref','region','remote_path','restart','size','size_bytes','started_at','status','structure','subfolders_locked?','transferred_bytes','type','with_rename')]
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="attempts,error,local_path,remote_path,size_bytes,status,started_at,transferred_bytes")]
[string[]]$fields = "attempts,error,local_path,remote_path,size_bytes,status,started_at,transferred_bytes",
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[int]$concurrentconnectionlimit,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[int]$retrycount,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[string]$ignore,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$SendLogsToCloud,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$sync,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         path = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         remotepath = @{
               OriginalName = ''
               OriginalPosition = '1'
               Position = '1'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         concurrentconnectionlimit = @{
               OriginalName = '--concurrent-connection-limit='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         retrycount = @{
               OriginalName = '--retry-count='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'int'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         ignore = @{
               OriginalName = '--ignore='
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         SendLogsToCloud = @{
               OriginalName = '--send-logs-to-cloud'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         sync = @{
               OriginalName = '--sync'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'upload'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
Uploads a file or folder to the site

.PARAMETER path
Specify the path to the local file to upload


.PARAMETER remotepath
Specify the path to files.com virtual directory


.PARAMETER fields
Fields to include in output


.PARAMETER concurrentconnectionlimit
(default 75)


.PARAMETER retrycount
On transfer failure retry number of times. (default 2)


.PARAMETER ignore
ignore files. See https://git-scm.com/docs/gitignore#_pattern_format


.PARAMETER SendLogsToCloud
Log output as external event


.PARAMETER sync
Only upload files with a more recent modified date


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Remove-FilesCliItem
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='Default')]
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,Mandatory=$true,ParameterSetName='GlobalFlags')]
[string]$path,
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[switch]$Recursive,
[ValidateSet('AllFields','action','created_at','crc32','display_name','download_uri','is_locked','length','md5','mime_type','mkdir_parents','mtime','part','parts','path','permissions','preview','preview_id','priority_color','provided_mtime','ref','region','restart','structure','subfolders_locked?','type','with_rename')]
[Parameter(ParameterSetName='Default')]
[Parameter(ParameterSetName='GlobalFlags')]
[PSDefaultValue(Value="display_name,created_at,mtime,path,permissions,type,size")]
[string[]]$fields = "display_name,created_at,mtime,path,permissions,type,size",
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         path = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Recursive = @{
               OriginalName = '--recursive=True'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--recursive=False'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         fields = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = 'privFilesCli_FieldsArrayToCommaSeparated'
               ArgumentTransformType = 'Function'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = 'privFilesCli_CommonJSONtoPSobjectHandler' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'files'
    $__commandArgs += 'delete'
    $__commandArgs += '--format=json,raw'
    $__commandArgs += '--use-pager=False'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
get detail on a folder or file

.PARAMETER path
Specify the path


.PARAMETER Recursive
If true, will recursively delete files in folders.  Otherwise, will error on non-empty folders.


.PARAMETER fields
Fields to include in output


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Set-FilesCliConfig
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(Mandatory=$true,ParameterSetName='Default')]
[string]$subdomain,
[Parameter(Mandatory=$true,ParameterSetName='Default')]
[string]$username,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         subdomain = @{
               OriginalName = '--subdomain'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         username = @{
               OriginalName = '--username'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{ Default = @{ StreamOutput = $true; Handler = { $input; Pop-CrescendoNativeError -EmitAsError } } }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'config'
    $__commandArgs += 'reset'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
set the config

.PARAMETER subdomain
Specify the name of subdomain


.PARAMETER username
Specify the name of user


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function Set-FilesCliConfig
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='Default')]

param(
[Parameter(Mandatory=$true,ParameterSetName='Default')]
[string]$subdomain,
[Parameter(Mandatory=$true,ParameterSetName='Default')]
[string]$username,
[Parameter()]
[string]$apikey,
[Parameter()]
[string]$debugOutputPath,
[Parameter()]
[switch]$CheckCliVersion,
[Parameter()]
[string]$output,
[Parameter()]
[string]$profile,
[Parameter()]
[string]$reauthentication
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         subdomain = @{
               OriginalName = '--subdomain'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         username = @{
               OriginalName = '--username'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         apikey = @{
               OriginalName = '--api-key='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         debugOutputPath = @{
               OriginalName = '--debug='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CheckCliVersion = @{
               OriginalName = '--ignore-version-check=False'
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $True
               DefaultMissingValue = '--ignore-version-check=True'
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         output = @{
               OriginalName = '--output='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         profile = @{
               OriginalName = '--profile='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         reauthentication = @{
               OriginalName = '--reauthentication='
               OriginalPosition = '3'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{ Default = @{ StreamOutput = $true; Handler = { $input; Pop-CrescendoNativeError -EmitAsError } } }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'config'
    $__commandArgs += 'set'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "files-cli.exe"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("files-cli.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "files-cli.exe")) {
          throw "Cannot find executable 'files-cli.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "files-cli.exe" $__commandArgs
            }
            else {
                & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "files-cli.exe" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Interact with Files.com api

.DESCRIPTION
set the config

.PARAMETER subdomain
Specify the name of subdomain


.PARAMETER username
Specify the name of user


.PARAMETER apikey
String of API key


.PARAMETER debugOutputPath
File Path for debug log


.PARAMETER CheckCliVersion
'True' or 'False' strings can be used


.PARAMETER output
file path to save output


.PARAMETER profile
Specify the profile string that was previously set


.PARAMETER reauthentication
Specify the password



.LINK
https://www.files.com/docs/integrations/command-line-interface-cli-app

#>
}


function privFilesCli_CommonJSONtoPSobjectHandler {
    begin {
        if ($__CrescendoNativeErrorQueue.Count -gt 0) {
            if ($__CrescendoNativeErrorQueue.Exception[0].message -match '^Error:\s') {
                $msg = $__CrescendoNativeErrorQueue.Dequeue()
                $__CrescendoNativeErrorQueue.clear()
                $er = [System.Management.Automation.ErrorRecord]::new([system.invalidoperationexception]::new($msg), $PSCmdlet.Name, "InvalidOperation", "files-cli $msg")
                $PSCmdlet.WriteError($er)
            } elseif ($__CrescendoNativeErrorQueue.Exception[0].message -match '^Usage:') {
                $msg = "Files-CLI did not accept this command. It returned a help doc which was suppressed."
                $__CrescendoNativeErrorQueue.clear()
                $er = [System.Management.Automation.ErrorRecord]::new([system.invalidoperationexception]::new($msg), $PSCmdlet.Name, "InvalidOperation", $msg)
                $PSCmdlet.WriteError($er)
            }
        }

    }
    PROCESS { 
        if ($args[0]) {
            try {
                $output_PSObject = $args[0] | ConvertFrom-Json -ea stop 
            } catch {
                #if for some reason the output dosn't come back as a json try to convert it
                $output_PSObject = $args[0] | ConvertTo-Json | ConvertFrom-Json
            }
            if ($output_PSObject.status -eq "errored") {
                throw "Files-cli = $($output_PSObject.error)"
            } else {
                $output_PSObject
            }
        } 
    } 
    END { 
        Pop-CrescendoNativeError -EmitAsError
    }
}
function privFilesCli_FieldsArrayToCommaSeparated {
    param([string[]]$v) 
    if ("AllFields" -in $v) {
        #All Fields will be shown
    } else {
        "--fields=" + ($v -join ',')
    }
}
function privFilesCli_UserOutPutHandler {
    begin {
        if ($__CrescendoNativeErrorQueue.Count -gt 0) {
            if ($__CrescendoNativeErrorQueue.Exception[0].message -match '^Error:\s') {
                $msg = $__CrescendoNativeErrorQueue.Dequeue()
                $__CrescendoNativeErrorQueue.clear()
                $er = [System.Management.Automation.ErrorRecord]::new([system.invalidoperationexception]::new($msg), $PSCmdlet.Name, "InvalidOperation", $msg)
                $PSCmdlet.WriteError($er)
            } elseif ($__CrescendoNativeErrorQueue.Exception[0].message -match '^Usage:') {
                $msg = "Files-CLI did not accept this command. It returned a help doc which was suppressed."
                $__CrescendoNativeErrorQueue.clear()
                $er = [System.Management.Automation.ErrorRecord]::new([system.invalidoperationexception]::new($msg), $PSCmdlet.Name, "InvalidOperation", $msg)
                $PSCmdlet.WriteError($er)
            }
        }

    }
    PROCESS {
        if ($args[0]) {
            $output_PSObject = $args[0] | ConvertFrom-Json | ForEach-Object {
                if ($_.admin_ids) { $_.admin_ids = $_.admin_ids.split(',') }
                if ($_.usernames) { $_.usernames = $_.usernames.split(',') }
                if ($_.user_ids) { $_.user_ids = $_.user_ids.split(',') }
                $_ 
            }
            if ($output_PSObject.status -eq "errored") {
                throw "Files-cli = $($output_PSObject.error)"
            } else {
                $output_PSObject
            }
        } 
    } 
    END { Pop-CrescendoNativeError }
    
}
function privFilesCli_DateTimeToGMTFilesFormat {
    param([datetime]$v) 
    Get-Date $v -UFormat "%Y-%m-%dT%H:%M:%S%Z:00"
}
function privFilesCli_BehaviorValue {
    param($v) 
    if ($PSEdition -eq "Core") {
        if ($v -is [pscustomobject]) {
            if ($v.key) {
                #replace newlines with \n for pgp keys
                $v.key = (($v.key) -join "`n") + "`n"
            }
            $formated = $v | ConvertTo-Json
        } elseif ($v -is [hashtable]) {
            if ($v.key) {
                #replace newlines with \n for pgp keys
                $v.key = (($v.key) -join "`n") + "`n"
            }
            $formated = $v | ConvertTo-Json
        } else {
            Write-Host "privFilesCli_BehaviorValue else passthru"
            $formated = $v
        }
    } else {
        if ($v -is [pscustomobject]) {
            Write-Verbose "privFilesCli_BehaviorValue pscustomobject"
            $formated = $v | ConvertTo-Json
            $formated = $formated -replace '"', '\"'
        } elseif ($v -is [hashtable]) {
            Write-Verbose "privFilesCli_BehaviorValue hashtable"
            $formated = $v | ConvertTo-Json
            $formated = $formated -replace '"', '\"'
        } else {
            Write-Verbose "privFilesCli_BehaviorValue else passthru"
            $formated = $v
        }
    }

    "--value=" + ($formated)
}
