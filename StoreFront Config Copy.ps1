# Script to copy StoreFront configs from on server group to another
# Script to copy StoreFront configs from on server group to another
# IIS Site ID's must be the same for the Source and Destinations 
# Powershell execution policy must be unrestricted
# No warranties are given by running this script


$Storename = "EEC"
$RemoteSFServer = "CTXSFTest"
$BackupFolder = "C:\Test"
$RemoteDir = "Test"
$HostBaseURL = "https://home.vhorizon.co.uk"

$SourceQuestion = Read-Host -Prompt "Is this server the source or Destination S/D?"

IF (Test-Path $BackupFolder -eq True) {} ELSE
{New-Item -path $BackupFolder -ItemType Directory}

If (Test-Path $RemoteSFServer\C$\$RemoteDir -eq True){} Else
{New-Item -path $RemoteSFServer\C$\$BackupFolder -ItemType Directory}

#IF statement imports Storefront Cmdlets and backs up current Storefront Store and configurations to a zip file
#ELSE statement assumes script is being run as destination mode, the script imports the storefront cmdlets
# exports the current storefront configuration as a Rollback config (in case of error) then applies the BackUp.zip config 

If ($SourceQuestion -eq 'S') {
#Execute Storefront cmslets and backup entire storefront configuration
& 'C:\Program Files\Citrix\Receiver StoreFront\Scripts\ImportModules.ps1'
Export-STFConfiguration -targetFolder "$BackupFolder" -zipfilename "Backup" -NoEncryption -force

#Copy backup zip file to target StoreFront Server
Robocopy $BackupFolder "\\$RemoteSFServer\C$\$RemoteDir" Backup.zip /is
} ELSE {
& 'C:\Program Files\Citrix\Receiver StoreFront\Scripts\ImportModules.ps1'
Export-STFConfiguration -targetFolder "$BackupFolder" -zipfilename "Rollback" -NoEncryption -force
Import-STFConfiguration -ConfigurationZip "$BackupFolder\Backup.zip" -HostBaseUrl "$HostBaseURL"
Start-DSClusterConfigurationUpdate
}

