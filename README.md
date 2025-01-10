# psFilesCLI
PowerShell module built with Crescendo for wrapping files-cli.exe commands to interact with Files.com

## Goals of this module:
- Provide syntax in line with what a PowerShell user would expect. For example the Command "files-cli Folders list-for /demo" is "Get-FilesCliChildItem -path /demo"
- Force files-cli json output to provide PSObject Output for all Functions
- Provide default flags that feel familiar to a PowerShell developer
- Include help and examples to improve built in documentation
- Use Crescendo to generate all Functions. Will not modify the psm1 after Crescendo has generated it. If any functionality is needed will reach out for feature request from Crescendo git issues page first before having any post generated module modification scripts.
- Build.ps1 to automate repeated parameters to improve consistency in generation of Crescendo JSON.
- Use Crescendo handlers to sanitize inputs and allow for flexibility with passing in parameters. For example allow use of [datetime] in time parameters rather than needing to use strings of how files-cli expects it to be formatted
- Only show common fields in output by default. Allow for the option of all available fields if needed.

## Files-CLI Installation
Download files-cli for your platform. Currently I have only tested with Windows x64 version https://github.com/Files-com/files-cli
Follow applicable instructions to add files-cli to your "Path". Optionally perform steps to set up Credentials in the default profile.

## psFilesCLI Installation
```PowerShell
Install-Module psFilesCLI -Force
```

## Credential notes
Since This module calls files-cli applicable profiles stored in "C:\\Users\\username\\.config\\files-cli" (on Windows) are used without any further configuration

-filesapikey or -filescliprofile can be used with most commands to override which profiles credentials are used.

Username and password authentication works but is not fully tested. If username/password credentials are expired commands may not error correctly. 

Currently storing the API key in as default profile is most reliable and removes need to provide api key or profile in every command.

## PowerShell Crescendo
This module is built with PowerShell Crescendo. Including -Verbose will show what files-cli string/parameters is used when running the command. 

```Powershell
Get-FilesCliChildItem -path "/demo" -Verbose
```
```
VERBOSE: files-cli.exe
VERBOSE: folders
VERBOSE: list-for
VERBOSE: --format=json,raw
VERBOSE: --use-pager=False
VERBOSE: --path=/demo
VERBOSE: --fields=display_name,mtime,path,permissions,type,size
VERBOSE: --with-previews=False
VERBOSE: --ignore-version-check=True
VERBOSE: Performing the operation "Get-FilesCliChildItem" on target "files-cli.exe folders list-for --format=json,raw --use-pager=False --path=/demo --fields=display_name,mtime,path,permissions,type,size --with-previews=False --ignore-version-check=True".
....
....
```

## Examples
### List a directory
```Powershell
Get-FilesCliChildItem -path "/demo"
```
```
display_name : Folder1
mtime        : 2/12/2023 10:17:18 PM
path         : Demo/Folder1
permissions  : lrwd
type         : directory

display_name : Folder2
mtime        : 2/12/2023 10:17:50 PM
path         : Demo/Folder2
permissions  : lrwd
type         : directory

display_name : File1.csv
mtime        : 2/12/2023 10:17:43 PM
path         : Demo/File1.csv
permissions  : lrwd
size         : 160797
type         : file

display_name : File2.csv
mtime        : 2/12/2023 10:17:45 PM
path         : Demo/File2.csv
permissions  : lrwd
size         : 160797
type         : file
```
### Download files using where-object
```Powershell
Get-FilesCliChildItem -path "/demo" |Where-Object {$_.display_name -like "*.csv"} | New-FilesCliDownload -localpath "C:\temp\localFilesDemoFolder"
```
```
attempts          : 1
error             : 
local_path        : C:\temp\localFilesDemoFolder\File1.csv
remote_path       : Demo/File1.csv
size_bytes        : 160797
status            : complete
transferred_at    : 2/12/2023 9:35:37 PM
transferred_bytes : 160797

attempts          : 1
error             : 
local_path        : C:\temp\localFilesDemoFolder\File2.csv
remote_path       : Demo/File2.csv
size_bytes        : 160797
status            : complete
transferred_at    : 2/12/2023 9:35:37 PM
transferred_bytes : 160797
```
### Using [datetime] to specify timespan for last 10 minutes for audit search
```Powershell
get-date
```
```
Sunday, February 12, 2023 9:42:16 PM
```
```Powershell
Get-FilesCliHistoriesListFolder -path /demo -startat get-date -endat (get-date).addminutes(-10)
```
```
action       : read
destination  : 
display      : 
failure_type : 
id           : 9999999999
interface    : restapi
ip           : 111.111.111.111
path         : Demo/File2.csv
source       : Demo/File2.csv
targets      : 
user_id      : 11111
username     : USER1
when         : 2/12/2023 9:35:37 PM

action       : read
destination  : 
display      : 
failure_type : 
id           : 9999999999
interface    : restapi
ip           : 111.111.111.111
path         : Demo/File1.csv
source       : Demo/File1.csv
targets      : 
user_id      : 11111
username     : USER1
when         : 2/12/2023 9:35:36 PM
```

### Set a Folder Behavior to Encrypt files with a public PGP key
```Powershell
$pubkey = Get-Content "C:\temp\pgp-pubkey.asc" -raw
$Behavior = @{
    behavior = "auto_encrypt"
    path     = "/Demo/AutoEncryptFolder"
    value    = @{
        algorithm = "PGP/GPG"
        suffix    = ".gpg"
        key       = "$pubkey"
        armor     = $false
    }
}
New-FilesCliBehavior @Behavior
```
```
behavior         id path                   value
--------         -- ----                   -----
auto_encrypt 999999 Demo/AutoEncryptFolder @{algorithm=PGP/GPG; armor=False; key_md5=123123123123abcabc123123; suffix=.gpg}
```

### Pipe IDs, Paths, Profiles etc in common into functions

Gets the items in the folder /Role/Test/Data from files.com then downloads them to c:\temp on the local computer
The profile used in the first command is passed into the downloaded as a non default field
```Powershell
Get-FilesCliChildItem -profile "dev" -path "/Role/Test/Data" | New-FilesCliDownload -localpath "c:\temp"
```
```
remote_path       : Role/Test/Data/file1.txt
local_path        : c:\temp\file1.txt
status            : complete
size_bytes        : 756
transferred_bytes : 756
started_at        : 1/7/2025 3:35:53 PM
completed_at      : 1/7/2025 3:35:53 PM
attempts          : 1

remote_path       : Role/Test/Data/2ndfile.txt
local_path        : c:\temp\2ndfile.txt
status            : complete
size_bytes        : 745
transferred_bytes : 745
started_at        : 1/7/2025 3:35:53 PM
completed_at      : 1/7/2025 3:35:53 PM
attempts          : 1

```

### Accepts securestring type or plain text for api keys
If an api key is used it will be converted to a securestring. Note it will be converted back to plain text before being passed to files-cli.
Keeping the api key as securestring for as long as possible helps prevent api keys being leaked but since we have to convert to plain text at some point there is still risk.
Notice: using -verbose will show the api key in plain text being passed to files-cli
Notice: The Filescli may still output the api key when -debugOutputPath is used

Example when a secure string is stored in Microsoft.PowerShell.SecretManagement
```Powershell
$secureString=get-secret "FilesComAPIKey"
Get-FilesCliChildItem -filesapikey $secureString -path / | select filesapikey
```
```
                 filesapikey
                 -----------
System.Security.SecureString
```

### Path autocomplete (tab completion) works for files.com file paths

Pressing Tab will start cycling actual folders in that location. if using an api or profile parameter it will be used for the lookup automatically.
This provides the feel of using Get-ChildItem but in files.com folders and files.

```Powershell
Get-FilesCliChildItem -profile dev -path /
#Tab once
Get-FilesCliChildItem -profile dev -path /Folder1
#Tab twice
Get-FilesCliChildItem -profile dev -path /Folder2
```

Pressing Tab will start cycling actual folders in that location 
```Powershell
Get-FilesCliChildItem -profile dev -path /Folder1/
#Tab once
Get-FilesCliChildItem -profile dev -path /Folder1/SubFolder1
#Tab twice
Get-FilesCliChildItem -profile dev -path /Folder1/SubFolder2
```

### Get file path permissions by piping to Get-FilesCliPermissionListByPath

```Powershell
Get-FilesCliItem -profile prd -path /Accounting/ReadOnly.txt | Get-FilesCliPermissionListByPath
```
```
group_id        : 5133
group_name      : Role.sso.IT
id              : 9999
path            :
permission      : history
recursive       : True
user_id         :
username        :
filescliprofile : prd

group_id        : 9999
group_name      : Role.sso.Accounting
id              : 9999
path            :
permission      : readonly
recursive       : True
user_id         :
username        :
filescliprofile : prd
```

### Get folder path permissions by user. The userid from the previous command is pipped to Get-FilesCliPermissionListByUser

```Powershell
Get-FilesCliUsersList -profile prd |Where-Object {$_.username -eq "johndoe"} | Get-FilesCliPermissionListByUser
```
```
group_id        :
group_name      :
id              : 9999
path            : FTP/johndoeFolder
permission      : full
recursive       : False
user_id         : 9999
username        : johndoe
filescliprofile : prd
```

### For a specific path in files.com request a file history export for the past 4 days, wait for the job to finish, then retrieve the audit. 

```Powershell
Get-FilesCliItem -path "/Role/ITOps/Data/test" -filescliprofile "dev" | New-FilesCliHistoryExport -startat (get-date).adddays(-4) | Wait-FilesCliHistoryExport | Receive-FilesCliHistoryExportResults
```
```
waiting for 5 secs then will check for job status again. current [building] for history job id [999999]
waiting for 5 secs then will check for job status again. current [building] for history job id [999999]
waiting for 5 secs then will check for job status again. current [building] for history job id [999999]
waiting for 5 secs then will check for job status again. current [ready] for history job id [999999]

action             : read
created_at_iso8601 : 1/7/2025 8:35:54 PM
destination        :
failure_type       : none
file_id            : 99999999
folder             : Role/ITOps/Data/test
id                 : 99999999
interface          : restapi
ip                 : 255.255.255.255
path               : Role/ITOps/Data/test/ps7.txt
src                : Role/ITOps/Data/test/ps7.txt
user_id            : 99999
username           : testuser

action             : read
created_at_iso8601 : 1/7/2025 8:35:54 PM
destination        :
failure_type       : none
file_id            : 99999999
folder             : Role/ITOps/Data/test
id                 : 99999999
interface          : restapi
ip                 : 255.255.255.255
path               : Role/ITOps/Data/test/ps7create.txt
src                : Role/ITOps/Data/test/ps7create.txt
user_id            : 99999
username           : testuser
```

