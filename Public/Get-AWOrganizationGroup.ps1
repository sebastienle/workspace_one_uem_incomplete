
function Get-AWOrganizationGroup {
	param (
		$Name,
		$Type,
		$GroupId
	)
	
	Process {
		try {
			$url = "$global:AWHostname/api/system/groups/search"
			
			if (($Name) -or ($Type) -or ($GroupId)) {
				$url = $url + "?"
			}
			
			if ($Name) {
				$url = $url + "name=$Name&"
			}
			if ($Type) {
				$url = $url + "type=$Type&"
			}
			if ($GroupId) {
				$url = $url + "groupid=$GroupId&"
			}
			
			if ($url.Substring($url.Length - 1, 1) -eq "&") {
				$url = $url.Substring(0, $url.Length - 1)
			}
			
			$resultFromRest = Invoke-RestMethod -Method Get -Uri $Url -Headers $global:AWAuthorizationHeaders -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
			Write-Verbose -Message '[Get-AWOrganizationGroup] Success getting audit information'
			
			return $resultFromRest.LocationGroups
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