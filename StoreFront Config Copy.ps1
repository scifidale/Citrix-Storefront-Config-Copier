# Script to copy StoreFront configs from on server group to another
# Script to copy StoreFront configs from on server group to another
# IIS Site ID's must be the same for the Source and Destinations 
# Powershell execution policy must be unrestricted
# No warranties are given by running this script


###### CHANGE THESE VARIABLES TO SUIT  #######
$RemoteSFServer = "CTXSFTest"
$BackupFolder = "C:\Test"
$RemoteDir = "Test"
$HostBaseURL = "https://home.vhorizon.co.uk"
###### END OF VARIABLES #####



$SourceQuestion = Read-Host -Prompt "Is this server the source or Destination S/D?"


# Checking Existance of Folders Specified above, creates them if it doesn't exist
$FolderCheck = Test-path "$BackupFolder"
$RemoteFolderCheck = Test-Path "\\$RemoteSFServer\C$\$RemoteDir"
IF ("$FolderCheck" -eq 'False') {New-Item -path $BackupFolder -ItemType Directory} ELSE{
}

IF ("$RemoteFolderCheck" -eq 'False'){Robocopy $backupFolder \\$RemoteSFServer\C$\$RemoteDir} Else{
}


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

