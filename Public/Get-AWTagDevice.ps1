
function Get-AWTagDevice {
	param (
		[Parameter(Mandatory)]
		$TagId
	)
	
	Process {
		try {
			$url = "$global:AWHostname/api/mdm/tags/$TagId/devices"
			
			$resultFromRest = Invoke-RestMethod -Method Get -Uri $Url -Headers $global:AWAuthorizationHeaders -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
			Write-Verbose -Message '[Get-AWTag] Success getting audit information'
			
			return $resultFromRest.Device
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