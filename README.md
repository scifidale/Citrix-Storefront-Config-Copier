# Citrix-Storefront-Config-Copier
creates a back up of a Citrix StoreFront configuration for migration to a new server group or for backup purposes


This simple script can be used to backup a StoreFront servers configuration using native StoreFront Powershell commandlets. 
Backups include all GUI configuable items in StoreFront (delivery controllers, Gateways etc) as well as Receiver for Web 
customisations within the /citrix/storeweb/custom folder. 

The script has a small amount of variables that require editing for your environment, but once it runs it will check for the presence
of the backup folders and create them if not already available. 

Choosing the Source(S) option will create a single backup of the StoreFront Configuration and then copies the .zip file accross to the
target server. This can be another storefront server or just a backup server. 

Choosing Destionation(D) from the script firstly creates a backup of the current storefront configuration (Rollback) and then applies 
the configuration copied from the source StoreFront server. 

As with all scripts please test before running in production and no warranties are implied or given. 


New text
