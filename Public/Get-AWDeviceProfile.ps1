
function Get-AWDeviceProfile {
	param (
		$Id = ""
	)
	Process {
		
		$url = "$global:AWHostname/api/mdm/devices/$Id/profiles"
		
		$resultFromRest = Invoke-RestMethod -Method Get -Uri $Url -Headers $global:AWAuthorizationHeaders -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
		Write-Verbose -Message '[Get-AWDeviceProfile] '
		
		return $resultFromRest.DeviceProfiles
		
	}
}