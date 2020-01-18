
function Get-AWEnrolledDevicesCount {
	param (
		$OrganizationGroupId,
		$TagName,
		$DeviceSeenSince,
		$DeviceSeenTill,
		$id,
		$uuid
	)
	
	Process {
		try {
			$url = "$global:AWHostname/api/mdm/devices/enrolleddevicescount"
			
			$bodyContent = @{
			}
			
			if ($OrganizationGroupId) {
				$bodyContent.add("OrganizationGroupId", "$OrganizationGroupId")
			}
			if ($TagName) {
				$bodyContent.add("TagName", "$TagName")
			}
			if ($DeviceSeenSince) {
				$bodyContent.add("DeviceSeenSince", "$DeviceSeenSince")
			}
			if ($DeviceSeenTill) {
				$bodyContent.add("DeviceSeenTill", "$DeviceSeenTill")
			}
			if ($id) {
				$bodyContent.add("id", "$id")
			}
			if ($uuid) {
				$bodyContent.add("uuid", "$uuid")
			}
			
			$bodyContentJSON = ConvertTo-Json -InputObject $bodyContent
			
			$resultFromRest = Invoke-RestMethod -Method Post -Uri $Url -Headers $global:AWAuthorizationHeaders -Body $bodyContentJSON -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
			Write-Verbose -Message '[Get-AWEnrolledDevicesCount] Success getting a count of enrolled devices'
			
			return $resultFromRest.DevicesCount
			
			#Write-Output -InputObject $Headers
		} catch {
			Write-Error -Exception $_.exception -ErrorAction Stop
		}
	}
	
}