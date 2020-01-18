
function Remove-AWDevice {
	param (
		[Parameter(Mandatory, ParameterSetName = 'QueryById')]
		$Id = ""
	)
	Process {
		Switch ($PSCmdlet.ParameterSetName) {
			'QueryById' {
				try {
					$url = "$global:AWHostname/api/mdm/devices/$id"
					
					$resultFromRest = Invoke-RestMethod -Method Delete -Uri $Url -Headers $global:AWAuthorizationHeaders -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
					Write-Verbose -Message '[Remove-AWDevice] Success deleting the device'
					
					# TO DO: IS THERE A RETURN CODE TO VERIFY FROM THIS ACTION? ANYTHING RETURNED? 
					
					# return $resultFromRest
					
					#Write-Output -InputObject $Headers
				} catch {
					Write-Error -Exception $_.exception -ErrorAction Stop
				}
			}
		}
	}
}