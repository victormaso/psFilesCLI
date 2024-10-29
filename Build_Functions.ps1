
function privFilesCli_FieldsArrayToCommaSeparated {
    param([string[]]$v) 
    if ("AllFields" -in $v) {
        #All Fields will be shown
    } else {
        "--fields=" + ($v -join ',')
    }
}

function privFilesCli_ScheduleObject {
    param ($v)
    
    if ($v.days_of_week -AND $v.time_zone -AND $v.times_of_day) {
        Write-Verbose "Schedule object has required members"
        $customobject=[PSCustomObject]@{
            days_of_week = $v.days_of_week
            time_zone    = $v.time_zone
            times_of_day = $v.times_of_day
        }
        $customobject |ConvertTo-Json -Compress -Depth 4
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