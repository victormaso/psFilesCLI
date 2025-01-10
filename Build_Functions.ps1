function privFilesCli_FieldsArrayToCommaSeparated {
    param([string[]]$v) 
    if ("AllFields" -in $v) {
        #All Fields will be shown
    } else {
        "--fields=" + ($v -join ',')
    }
}


function privFilesCli_ApiSecureStringToText {
    param($v) 
    $apikeyOrig = $v

    if ($apikeyOrig) {
        if ($apikeyOrig.gettype() -like "*SecureString") {
            if ($PSEdition -eq "Core") {
                $apiKeyText = ConvertFrom-SecureString -SecureString $apikeyOrig -AsPlainText
            } else {
                $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($apikeyOrig)
                $apiKeyText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
                [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
            }
        } else {
            $apiKeyText = $apikeyOrig
        }
        [string]$apiKeyText
    } 

}

function privFilesCli_WaitHistoryJobPSobjectHandler {
    process {
        $OriginalPSObject = $args[0] | ConvertFrom-Json

        $params = @{}
        if ($filescliprofile) { $params += @{"filescliprofile" = $filescliprofile } }
        if ($filesapikey) { $params += @{"filesapikey" = $filesapikey } }
        if ($OriginalPSObject.id) { $params += @{"id" = $OriginalPSObject.id } }

        $jobStatus = $OriginalPSObject
        $retries = 0
        while ($jobStatus.status -ne "ready" -or ($retries -gt 5)) {
            $jobStatus = Get-FilesCliHistoryExport @params
            write-host "waiting for 5 secs then will check for job status again. current [$($jobstatus.status)] for history job id [$($jobstatus.id)]"
            Start-Sleep 5
            $retries++
        }


        privFilesCli_CommonJSONtoPSobjectHandler ($jobStatus | ConvertTo-Json -Compress)
    }
}


function privFilesCli_ScheduleObject {
    param ($v)
    
    if ($v.days_of_week -AND $v.time_zone -AND $v.times_of_day) {
        Write-Verbose "Schedule object has required members"
        $customobject = [PSCustomObject]@{
            days_of_week = $v.days_of_week
            time_zone    = $v.time_zone
            times_of_day = $v.times_of_day
        }
        $customobject | ConvertTo-Json -Compress -Depth 4
    } else {
        throw "Schedule object require days_of_week -AND time_zone -AND times_of_day."
    }
    #example json {"days_of_week":[0,1,2,3,4,5,6],"time_zone":"Central Time (US & Canada)","times_of_day":["00:44","01:44","02:44","03:44","04:44","05:44","06:44","07:44","08:44","09:44","10:44","11:44","12:44","13:44","14:44","15:44","16:44","17:44","18:44","19:44","20:44","21:44","22:44","23:44"]}
}

function privFilesCli_ArrayToCommaSeparated {
    param([string[]]$v) 
    $valuestring = ($v -join '","')
    '"["' + $valuestring + '"]"'
}
function privFilesCli_ArrayToCommaSeparatedInt {
    param([int[]]$v) 
    $valuestring = ($v -join ',')
    '"[' + $valuestring + ']"'
}

function privFilesCli_DateTimeToGMTFilesFormat {
    param([datetime]$v) 
    Get-Date $v -UFormat "%Y-%m-%dT%H:%M:%S%Z:00"
}



function privFilesCli_CommonJSONtoPSobjectHandler {
    begin {
        if ($args[0] -like "*Enter your site subdomain (e.g. mysite) or custom domain*") {
            $er = [System.Management.Automation.ErrorRecord]::new([system.invalidoperationexception]::new($msg), $PSCmdlet.Name, "InvalidOperation", "files-cli Files-cli was asking for user input. Cannot handle. Error [$($args[0])]")
            $PSCmdlet.WriteError($er)
        }
        function SubFunction_FilesCLIErrorOutputHandler {
            if ($__CrescendoNativeErrorQueue.Count -gt 0) {
                if ($__CrescendoNativeErrorQueue.Exception[0].message -match "^Error: Invalid Cursor") {
                    $msg = $__CrescendoNativeErrorQueue.Dequeue()
                    $__CrescendoNativeErrorQueue.clear()
                    $er = [System.Management.Automation.ErrorRecord]::new([system.invalidoperationexception]::new($msg), $PSCmdlet.Name, "InvalidCursor", "files-cli $msg [Results are likely incomplete. This is usually a files.com issue where a support case is needed.]")
                    $PSCmdlet.WriteError($er)
                } elseif ($__CrescendoNativeErrorQueue.Exception[0].message -match '^Error:\s') {
                    $msg = $__CrescendoNativeErrorQueue.Dequeue()
                    $__CrescendoNativeErrorQueue.clear()
                    $er = [System.Management.Automation.ErrorRecord]::new([system.invalidoperationexception]::new($msg), $PSCmdlet.Name, "InvalidOperation", "files-cli $msg")
                    $PSCmdlet.WriteError($er)
                } elseif ($__CrescendoNativeErrorQueue.Exception[0].message -match '^Usage:') {
                    $msg = "Files-CLI did not accept this command. It returned a help doc which was suppressed."
                    $__CrescendoNativeErrorQueue.clear()
                    $er = [System.Management.Automation.ErrorRecord]::new([system.invalidoperationexception]::new($msg), $PSCmdlet.Name, "InvalidOperation", $msg)
                    $PSCmdlet.WriteError($er)
                } elseif ($__CrescendoNativeErrorQueue.Exception[0].message -match 'version .*? is out of date') {
                    $msg = $__CrescendoNativeErrorQueue -join '
                    '
                    $__CrescendoNativeErrorQueue.clear()
                    $er = [System.Management.Automation.ErrorRecord]::new([system.invalidoperationexception]::new($msg), $PSCmdlet.Name, "VersionOutOfDate", $msg)
                    $PSCmdlet.WriteWarning($er)
                } else {
                    $msg = $__CrescendoNativeErrorQueue -join '
                    '
                    $__CrescendoNativeErrorQueue.clear()
                    $er = [System.Management.Automation.ErrorRecord]::new([system.invalidoperationexception]::new($msg), $PSCmdlet.Name, "InvalidOperation", "GeneralFilesCLIError: $msg")
                    $PSCmdlet.WriteError($er)
                }
            }
        }
        
        
        function SubFunction_FilesCLITypeCalculator {
            param(
                [string[]]$argsValuesFromCommand,
                $outputMessage
            )
            try {
                $CmdPart0 = $argsValuesFromCommand[0]
            } catch {}
            try {
                $CmdPart1 = $argsValuesFromCommand[1]
            } catch {}
        
        
            switch ($CmdPart0) {
                { $_ -in "files" -and ($CmdPart1 -in "copy", "move") } {
                    if ($outputMessage -like '*"file_migration_id"*') {
                        [PSCustomObject]@{
                            psobject_type = 'FilesCLI.MFT.JobDispatched'
                        }
                    } else {
                        [PSCustomObject]@{
                            psobject_type = 'FilesCLI.MFT.JobSummary'
                        }
                    }
                    Break
                }
                { $_ -in "files", "folders" } {
                    [PSCustomObject]@{
                        psobject_type     = 'FilesCLI.MFT.Item'
                        defaultDisplaySet = 'display_name', 'path', 'mime_type', 'size', 'size_MB', 'type', 'permissions', 'created_at', 'provided_mtime', 'mtime'
                    }
                    Break
                }
                { $_ -in "download", "upload" } {
                    [PSCustomObject]@{
                        psobject_type     = 'FilesCLI.MFT.Transfer'
                        defaultDisplaySet = 'remote_path', 'local_path', 'status', 'size_bytes', 'transferred_bytes', 'started_at', 'completed_at', 'attempts'
                    }
                    Break
                }
                { $_ -in "group-users", "groups" } {
                    [PSCustomObject]@{
                        psobject_type     = 'FilesCLI.Admin.Groups'
                        defaultDisplaySet = "id", "admin_ids", "user_ids", "usernames", "notes", "allowed_ips", "dav_permission", "ftp_permission", "restapi_permission"
                    }
                    Break
                }
                { $_ -in "users" } {
                    [PSCustomObject]@{
                        psobject_type     = 'FilesCLI.Admin.Users'
                        defaultDisplaySet = "id", "username", "name", "email", "disabled", "group_ids", "authentication_method", "last_login_at", "last_active_at", "password_expired"
                    }
                    Break
                }
                { $_ -in "history-export-results" } {
                    [PSCustomObject]@{
                        psobject_type     = 'FilesCLI.Audit.HistoryExportResults'
                        defaultDisplaySet = "action", "created_at_iso8601", "destination", "failure_type", "file_id", "folder", "id", "interface", "ip", "path", "src", "user_id", "username"
                    }
                    Break
                }
                { $_ -in "permissions" } {
                    [PSCustomObject]@{
                        psobject_type = 'FilesCLI.Admin.Permissions'
                    }
                    Break
                }
                { $_ -in "remote-servers" } {
                    [PSCustomObject]@{
                        psobject_type     = 'FilesCLI.Admin.RemoteServers'
                        defaultDisplaySet = "id", "name", "server_type", "remote_home_path", "disabled", "hostname", "username", "max_connections", "authentication_method", "enable_dedicated_ips", "pin_to_site_region", "server_host_key", "port", "server_certificate"
                    }
                    Break
                }
                Default {
                    [PSCustomObject]@{
                        psobject_type = 'FilesCLI.General'
                    }
                }
            }
        
        
        }
        SubFunction_FilesCLIErrorOutputHandler
    }
    PROCESS { 
        if ($args[0]) {
            $args.Split([Environment]::NewLine)  | ForEach-Object {
                $message = $_
                if ($message -match '^\d\d\d\d\/\d\d\/\d\d \d\d:\d\d:\d\d\s') {
                    #when -debugOutputPath STDOUT is used write the debug output to host.
                    write-host "$($message)"
                } else {

                    try {
                        if ($message -match '^(\[|{)') {
                            $output_PSObject_unTyped = $message | ConvertFrom-Json -ea stop 
                        }
                    } catch {
                        #if for some reason the output dosn't come back as a json try to convert it
                        $output_PSObject_unTyped = $message | ConvertTo-Json | ConvertFrom-Json
                    }
                    if ($output_PSObject_unTyped.status -eq "errored") {
                        throw "Files-cli = $($output_PSObject.error)"
                    } else {
                        foreach ($output_PSObject in $output_PSObject_unTyped) {
                            #convert comma seperated to array
                            if ($output_PSObject.admin_ids) { $output_PSObject.admin_ids = $output_PSObject.admin_ids.split(',') }
                            if ($output_PSObject.usernames) { $output_PSObject.usernames = $output_PSObject.usernames.split(',') }
                            if ($output_PSObject.user_ids) { $output_PSObject.user_ids = $output_PSObject.user_ids.split(',') }
                            if ($output_PSObject.size) { $output_PSObject | Add-Member -NotePropertyName "size_MB" -NotePropertyValue ($output_PSObject.size / 1MB) -Force }

                            #gets the type and updates the new psobject
                            $CLIObjectType = SubFunction_FilesCLITypeCalculator -argsValuesFromCommand $__commandArgs -outputMessage $message

                            $output_PSObject.PSObject.TypeNames.Insert(0, $CLIObjectType.psobject_type)

                            #add profile to parameters. This helps with pipping to allow the profiles used in the previous command to be assumed to be used in the next pipped.
                            if ($filescliprofile -notmatch '(\\)|(/)') {
                                $output_PSObject | Add-Member -NotePropertyName "filescliprofile" -NotePropertyValue $filescliprofile -Force
                            }
                            if ($filesapikey) {
                                if ($filesapikey.gettype() -like "*SecureString") {
                                    $output_PSObject | Add-Member -NotePropertyName "filesapikey" -NotePropertyValue $filesapikey -Force
                                } else {
                                    $secureApiKey = ConvertTo-SecureString -String $filesapikey -AsPlainText -Force
                                    $output_PSObject | Add-Member -NotePropertyName "filesapikey" -NotePropertyValue   $secureApiKey -Force
                                }
                            }

                            if ($CLIObjectType.defaultDisplaySet) {
                                #Create the default property display set
                                $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', [string[]]$CLIObjectType.defaultDisplaySet)
                                $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)
                                $output_PSObject | Add-Member MemberSet PSStandardMembers $PSStandardMembers -Force
                            } 
                            #convert gmt to local time
                            $output_PSObject.PSObject.Properties | ForEach-Object {
                                if ($_.Value -is [DateTime]) {
                                    $_.Value = $_.Value.ToLocalTime()
                                }
                            }

                            #return updated object
                            $output_PSObject
                        }
                    }
                }
            }
        } 
    } 
    END { 
        Pop-CrescendoNativeError -EmitAsError
    }
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

