
# Exportable Function
function Get-AWProfilePayloadKeys {
	[CmdletBinding()]
	param (
#		[Parameter(Mandatory = $true,
#				   ValueFromPipelineByPropertyName = $true)]
#		[int]$ContextType,
		[Parameter(Mandatory = $true,
			 ValueFromPipelineByPropertyName = $true)]
		[ValidateSet("Android Container", "Android for Work", "Credentials", "CustomSettings", "EAS", "Email", "Passcode", "Restrictions", "SCEP", "TouchDown Credentials", "VPN", "Wi-Fi" )]
		[string]$Payload,
		[Parameter(Mandatory = $true,
			 ValueFromPipelineByPropertyName = $true)]
		[ValidateSet("Android","Apple")]
		[string]$Platform
	)
	
	Process {
		Write-Verbose -Message "[Get-AWProfilePayloadKeys] Process"
		
		[boolean]$changedHeader = $false
		
		$url = "$global:AWHostname/api/mdm/profiles/platforms/$Platform/payloads/$Payload/getpayloadkeys"
		
		if ($global:AWAuthorizationMechanism -eq "Certificate") {
			$global:AWAuthorizationHeaders.Authorization = "$(Get-CMSURLAuthorizationHeader -URL $Url -Certificate $global:AWAuthorizationCertificate)"
		}
		
		#API v2 Enablement
		if (($global:AWAuthorizationHeaders.ContainsKey("Accept") -eq $false) -or ($global:AWAuthorizationHeaders['Accept'].ToUpper().Trim() -ne "application/json;version=2")) {
			$changedHeader = $true
			$global:AWAuthorizationHeaders['Accept'] = "application/json;version=2"
		}
		
		Write-Verbose -Message "[Get-AWProfilePayloadKeys] URL: $url"
		Write-Verbose -Message "[Get-AWProfilePayloadKeys] Query for profile payload keys"
		$resultFromRest = Invoke-RestMethod -Method Get -Uri $Url -Headers $global:AWAuthorizationHeaders -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
		Write-Verbose -Message "[Get-AWProfilePayloadKeys] Query completed successfully"
		
		#API v2 Removal
		if ($changedHeader -eq $true) {
			$global:AWAuthorizationHeaders.Remove("Accept")
		}
		
		switch ($Payload.ToUpper().Trim()) {
			"EAS" {
				return $resultFromRest.ExchangeActiveSync
			}
			default {
				return $resultFromRest
			}
		}
	
	}
}