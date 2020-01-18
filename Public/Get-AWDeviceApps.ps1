
function Get-AWDeviceApps {
	param (
		$DeviceId = ""
	)
	Process {
		
		$url = "$global:AWHostname/api/mdm/devices/$DeviceId/apps"
		
		$resultFromRest = Invoke-RestMethod -Method Get -Uri $Url -Headers $global:AWAuthorizationHeaders -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
		Write-Verbose -Message '[Get-AWDeviceApps] '
		
		return $resultFromRest.DeviceApps
		
	}
}