﻿
function Get-AWDeviceGps {
	param (
		$DeviceId = ""
	)
	Process {
		
		$url = "$global:AWHostname/api/mdm/devices/$DeviceId/gps"
		
		if ($global:AWAuthorizationMechanism -eq "Certificate") {
			$global:AWAuthorizationHeaders.Authorization = "$(Get-CMSURLAuthorizationHeader -URL $Url -Certificate $global:AWAuthorizationCertificate)"
		}
		
		$resultFromRest = Invoke-RestMethod -Method Get -Uri $Url -Headers $global:AWAuthorizationHeaders -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
		Write-Verbose -Message '[Get-AWDeviceGps] Obtained GPS information'
		
		return $resultFromRest
		
	}
}