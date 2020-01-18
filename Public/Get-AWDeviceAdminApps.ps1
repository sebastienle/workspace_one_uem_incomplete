
function Get-AWDeviceAdminApps {
	param (
		$Id = ""
	)
	Process {
		
		$url = "$global:AWHostname/api/mdm/devices/$Id/adminapps"
		
		$resultFromRest = Invoke-RestMethod -Method Get -Uri $Url -Headers $global:AWAuthorizationHeaders -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
		Write-Verbose -Message '[Get-AWDeviceAdminApps] '
		
		return $resultFromRest.DeviceAdminApps
		
	}
}