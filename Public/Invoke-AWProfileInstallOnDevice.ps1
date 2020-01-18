
function Invoke-AWProfileInstallOnDevice {
	param (
		[Parameter(Mandatory)]
		$DeviceID,
		[Parameter(Mandatory)]
		$ProfileId = ""
	)
	Process {
		try {
			$url = "$global:AWHostname/api/mdm/profiles/$ProfileId/install"
			
			$bodyContent = @{
				"DeviceId"	     = "$DeviceID"
			}
			$bodyContentJSON = ConvertTo-Json -InputObject $bodyContent
			
			if ($global:AWAuthorizationMechanism -eq "Certificate") {
				$global:AWAuthorizationHeaders.Authorization = "$(Get-CMSURLAuthorizationHeader -URL $Url -Certificate $global:AWAuthorizationCertificate)"
			}
			
			Invoke-RestMethod -Method Post -Uri $Url -Headers $global:AWAuthorizationHeaders -Body $bodyContentJSON -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
			Write-Verbose -Message '[Invoke-AWProfileInstallOnDevice] Pushed profile on device'
			
			# return $resultFromRest.Devices
			
			#Write-Output -InputObject $Headers
		} catch {
			Write-Error -Exception $_.exception -ErrorAction Stop
		}
	}
}