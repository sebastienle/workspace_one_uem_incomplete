
function Set-AWDevicePasscode {
	param (
		[Parameter(Mandatory)]
		$DeviceID,
		[Parameter(Mandatory)]
		$NewPasscode = ""
	)
	Process {
		try {
			$url = "$global:AWHostname/api/mdm/devices/$DeviceID/commands/changepasscode"
			
			$bodyContent = @{
				"Passcode"	     = "$NewPasscode"
			}
			$bodyContentJSON = ConvertTo-Json -InputObject $bodyContent
			
			if ($global:AWAuthorizationMechanism -eq "Certificate") {
				$global:AWAuthorizationHeaders.Authorization = "$(Get-CMSURLAuthorizationHeader -URL $Url -Certificate $global:AWAuthorizationCertificate)"
			}
			
			Invoke-RestMethod -Method Post -Uri $Url -Headers $global:AWAuthorizationHeaders -Body $bodyContentJSON -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
			Write-Verbose -Message '[Set-AWDevicePasscode] Success setting the device passcode'
			
		} catch {
			Write-Error -Exception $_.exception -ErrorAction Stop
		}
	}
}