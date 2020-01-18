
function Get-AWTag {
	param (
		$Name,
		[Parameter(Mandatory)]
		$OrganizationGroupId,
		$TagType
	)
	
	Process {
		try {
			$url = "$global:AWHostname/api/mdm/tags/search"
			
			if (($Name) -or ($OrganizationGroupId) -or ($TagType)) {
				$url = $url + "?"
			}
			
			if ($Name) {
				$url = $url + "name=$Name&"
			}
			if ($OrganizationGroupId) {
				$url = $url + "OrganizationGroupId=$OrganizationGroupId&"
			}
			if ($TagType) {
				$url = $url + "TagType=$TagType&"
			}
			
			if ($url.Substring($url.Length - 1, 1) -eq "&") {
				$url = $url.Substring(0, $url.Length - 1)
			}
			
			$resultFromRest = Invoke-RestMethod -Method Get -Uri $Url -Headers $global:AWAuthorizationHeaders -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
			Write-Verbose -Message '[Get-AWTag] Success getting audit information'
			
			return $resultFromRest.Tags
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