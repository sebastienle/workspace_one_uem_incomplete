#Get public and private function definition files.
$Public = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

#Dot source the files
Foreach ($import in @($Public + $Private)) {
	Try {
		. $import.fullname
	} Catch {
		Write-Error -Message "Failed to import function $($import.fullname): $_"
	}
}

#Global Module Variables
##Environment Setup - Hostname and Proxy Info
##TO DO - ALLOW USER TO SAVE THEIR ENV INFO TO A JSON FILE AND LOAD IT AND NAME THEM
[boolean]$script:AWEnvironmentSet = $false
[string]$script:AWHostname = ""
[boolean]$script:AWUseProxy = $false
[string]$script:AWProxyServer = ""
[string]$script:AWProxyAuthentication = "" #ProxyUseDefaultCredentials

##Authentication
[boolean]$script:AWAuthorizationDefined = $false
[string]$script:AWAuthorizationMechanism = ""
[System.Security.Cryptography.X509Certificates.X509Certificate2]$script:AWAuthorizationCertificate
[hashtable]$script:AWAuthorizationHeaders = @{}


# Here I might...
# Read in or create an initial config file and variable
# Export Public functions ($Public.BaseName) for WIP modules
# Set variables visible to the module and its functions only

Export-ModuleMember -Function $Public.Basename
