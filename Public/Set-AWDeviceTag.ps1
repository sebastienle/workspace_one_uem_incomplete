
function Set-AWDeviceTag {
	param (
		[Parameter(Mandatory)]
		$DeviceID,
		[Parameter(Mandatory)]
		$TagId
	)
	Process {
		try {
			$url = "$global:AWHostname/api/mdm/tags/$TagId/adddevices"
			
			$bodyContent = @{
				"BulkValues" = @{
					"Value" = @("$DeviceID")
				}
			}
			$bodyContentJSON = ConvertTo-Json -InputObject $bodyContent
			
			Invoke-RestMethod -Method Post -Uri $Url -Headers $global:AWAuthorizationHeaders -Body $bodyContentJSON -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
			Write-Verbose -Message '[Set-AWDeviceTag] Success adding tag to device'
			
			} catch {
			Write-Error -Exception $_.exception -ErrorAction Stop
		}
	}
}