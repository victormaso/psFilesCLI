@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'psFilesCli.psm1'
    
    # Version number of this module.
    ModuleVersion = '0.1.3'
    
    # Supported PSEditions
    # CompatiblePSEditions = @()
    
    # ID used to uniquely identify this module
    GUID = 'd491255e-3bd7-4d82-9c98-6f5459c126c9'
    
    # Author of this module
    Author = 'Victor Maso'
    
    # Company or vendor of this module
    #CompanyName = ''
    
    # Copyright statement for this module
    Copyright = '(c) Victor Maso. All rights reserved.'
    
    # Description of the functionality provided by this module
    Description = 'A PowerShell wrapper for files-cli.exe'
    
    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1.0'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Copy-FilesCliItem', 'Get-FilesCliApiKeysFind', 
               'Get-FilesCliApiKeysList', 'Get-FilesCliApiRequestLogs', 
               'Get-FilesCliAutomationLogs', 'Get-FilesCliAutomationRunsFind', 
               'Get-FilesCliAutomationRunsList', 'Get-FilesCliAutomationsList', 
               'Get-FilesCliBehaviors', 'Get-FilesCliBehaviorsByPath', 
               'Get-FilesCliChildItem', 'Get-FilesCliConfig', 
               'Get-FilesCliEmailIncomingMessages', 'Get-FilesCliEmailLogs', 
               'Get-FilesCliExternalEventsList', 'Get-FilesCliFileMigrationLogs', 
               'Get-FilesCliFtpActionLogs', 'Get-FilesCliGroupsList', 
               'Get-FilesCliGroupMembers', 'Get-FilesCliUserGroupMembership', 
               'Get-FilesCliHistoriesList', 'Get-FilesCliHistoriesListFile', 
               'Get-FilesCliHistoriesListFolder', 
               'Get-FilesCliHistoriesListLogins', 'Get-FilesCliHistoryExport', 
               'Get-FilesCliHistoryExportResults', 'Get-FilesCliIPAddressesList', 
               'Get-FilesCliItem', 'Get-FilesCliNotifications', 
               'Get-FilesCliPermissionList', 'Get-FilesCliRemoteServerById', 
               'Get-FilesCliRemoteServersList', 'Get-FilesCliSettingsChanges', 
               'Get-FilesCliSftpActionLogs', 'Get-FilesCliSyncLogs', 
               'Get-FilesCliUsageDailySnapshots', 'Get-FilesCliUser', 
               'Get-FilesCliUserCipherUses', 'Get-FilesCliUsersList', 
               'Move-FilesCliItem', 'New-FilesCliBehavior', 'New-FilesCliDownload', 
               'New-FilesCliFolder', 'New-FilesCliHistoryExport', 
               'New-FilesCliSyncPull', 'New-FilesCliUpload', 'Remove-FilesCliItem', 
               'Set-FilesCliConfig', 'Set-FilesCliConfig', 'New-FilesCliAutomation',
               'Get-FilesCliAutomationRuns','Get-FilesCliOutboundConnectionLogs'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('files-cli.exe','Files-CLI','files.com','CrescendoBuilt')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/victormaso/psFilesCLI/blob/main/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/victormaso/psFilesCLI'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable


    # CrescendoVersion
    CrescendoVersion = '1.1.0'

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}