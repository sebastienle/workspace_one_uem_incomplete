
# Exportable Function
function Get-AWProfileDetail {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true)]
		[int]$Id
	)
	
	Process {
		Write-Verbose -Message "[Get-AWProfileDetail] Process"
		
		[boolean]$changedHeader = $false
		
		$url = "$global:AWHostname/api/mdm/profiles/$Id"
				
		if ($global:AWAuthorizationMechanism -eq "Certificate") {
			$global:AWAuthorizationHeaders.Authorization = "$(Get-CMSURLAuthorizationHeader -URL $Url -Certificate $global:AWAuthorizationCertificate)"
		}
		
		#API v2 Enablement
		if (($global:AWAuthorizationHeaders.ContainsKey("Accept") -eq $false) -or ($global:AWAuthorizationHeaders['Accept'].ToUpper().Trim() -ne "application/json;version=2")) {
			$changedHeader = $true
			$global:AWAuthorizationHeaders['Accept'] = "application/json;version=2"
		}
		
		Write-Verbose -Message "[Get-AWProfileDetail] URL: $url"
		Write-Verbose -Message "[Get-AWProfileDetail] Query for profile"
		$resultFromRest = Invoke-RestMethod -Method Get -Uri $Url -Headers $global:AWAuthorizationHeaders -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
		Write-Verbose -Message "[Get-AWProfileDetail] Query completed successfully"
		
		#API v2 Removal
		if ($changedHeader -eq $true) {
			$global:AWAuthorizationHeaders.Remove("Accept")
		}
		
		return $resultFromRest
		
		
	}
}