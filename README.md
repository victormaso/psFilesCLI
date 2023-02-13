# psFilesCLI
PowerShell module built with Crescendo for wrapping files-cli.exe commands to interact with Files.com

# Files-CLI Installation
Download files-cli for your platform. Currently I have only tested with Windowsx64 version https://github.com/Files-com/files-cli
Follow applicable instructions to add files-cli to your "Path". Optionally perform steps to set up Credentials.

# psFilesCLI Installation
```PowerShell
Install-Module psFilesCLI -Force
```

# Credential notes
Since This module calls files-cli applicable profiles stored in "C:\\user\\.config\\" (on Windows) are used without any further configuration

-apikey or -profile can be used with most commands to override which profiles credentials are used.

Username and password authentication works but is not fully. If username/password credentials are expired commands may not error correctly. 

Currently storing the API key in as default profile is most reliable and removes need to provide api key in every command.

# PowerShell Crescendo
This module is built with PowerShell Crescendo. Including -Verbose will show what files-cli string/parameters is used.
