
function Set-AWEnvironment {
	param (
		[Parameter(Mandatory = $true)]
		[string]$Hostname,
		[switch]$UseProxy,
		[string]$ProxyServer,
		[string]$ProxyAuthentication
	)
	
	$global:AWHostname = $Hostname
	$global:AWEnvironmentSet = $true
	
	if ($UseProxy) {
		[boolean]$global:AWUseProxy = $true
		[string]$global:AWProxyServer = "$ProxyServer"
		[string]$global:AWProxyAuthentication = "$ProxyAuthentication"
	}
}