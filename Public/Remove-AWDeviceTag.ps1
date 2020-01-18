
function Remove-AWDeviceTag {
	param (
		[Parameter(Mandatory)]
		$DeviceID,
		[Parameter(Mandatory)]
		$TagId
	)
	Process {
		try {
			$url = "$global:AWHostname/api/mdm/tags/$TagId/removedevices"
			
			$bodyContent = @{
				"BulkValues" = @{
					"Value" = @("$DeviceID")
				}
			}
			$bodyContentJSON = ConvertTo-Json -InputObject $bodyContent
			
			Invoke-RestMethod -Method Post -Uri $Url -Headers $global:AWAuthorizationHeaders -Body $bodyContentJSON -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
			Write-Verbose -Message '[Remove-AWDeviceTag] Success removing tag from device'
			
			# return $resultFromRest.Devices
			
			#Write-Output -InputObject $Headers
		} catch {
			Write-Error -Exception $_.exception -ErrorAction Stop
		}
	}
}