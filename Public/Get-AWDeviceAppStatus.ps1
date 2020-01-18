
function Get-AWDeviceAppStatus {
	param (
		#searchBy
		$Id,
		$GroupId,
		$BundleId,
		$Version,
		$DeviceType
	)
	
	Process {
		try {
			$url = "$global:AWHostname/api/mdm/devices/appstatus"
			
			if (($Id) -or ($GroupId) -or ($BundleId) -or ($Version) -or ($DeviceType)) {
				$url = "$url" + "?"
			}
			if ($Id) {
				$url = "$url" + "id=$Id"
			}
			if ($GroupId) {
				$url = "$url" + "groupid=$GroupId"
			}
			if ($BundleId) {
				$url = "$url" + "bundleid=$BundleId"
			}
			if ($Version) {
				$url = "$url" + "version=$Version"
			}
			if ($DeviceType) {
				$url = "$url" + "devicetype=$DeviceType"
			}
			
			$resultFromRest = Invoke-RestMethod -Method Get -Uri $Url -Headers $global:AWAuthorizationHeaders -Body $bodyContentJSON -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
			Write-Verbose -Message '[Get-AWDeviceAppStatus] '
			
			return $resultFromRest.DevicesCount
		} catch {
			# Note: This returns an error when the query returns no result - this should not be
			# # Dig into the exception to get the Response details.
			# Note that value__ is not a typo.
			#Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__
			#Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
			Write-Error -Exception $_.exception -ErrorAction Stop
		}
	}
	
}