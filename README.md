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

-apikey or -profile can be used with most commands to override which profiles credentials are used.

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