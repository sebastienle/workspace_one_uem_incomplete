
# Exportable Function
function Get-AWProfile {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false,
				   ValueFromPipelineByPropertyName = $true)]
		[boolean]$IncludeAndroidForWork,
		[Parameter(Mandatory = $false,
				   ValueFromPipelineByPropertyName = $true)]
		[int]$OrganizationGroupId,
		[Parameter(Mandatory = $false,
				   ValueFromPipelineByPropertyName = $true)]
		[string]$Platform,
		[Parameter(Mandatory = $false,
				   ValueFromPipelineByPropertyName = $true)]
		[string]$ProfileType,
		[Parameter(Mandatory = $false,
				   ValueFromPipelineByPropertyName = $true)]
		[string]$Status,
		[Parameter(Mandatory = $false,
				   ValueFromPipelineByPropertyName = $true)]
		[string]$SearchText
	)
	
	Process {
		Write-Verbose -Message "[Get-AWProfile] Process"
		
		$url = "$global:AWHostname/api/mdm/profiles/search?"
		Write-Verbose -Message "[Get-AWProfile] Starting URL: $url"
		
		if ($IncludeAndroidForWork) {
			$url = "$url" + "includeandroidforwork=$IncludeAndroidForWork" + "&"
		}
		if ($OrganizationGroupId) {
			$url = "$url" + "organizationgroupid=$OrganizationGroupId" + "&"
		}
		if ($Platform) {
			$url = "$url" + "platform=$Platform" + "&"
		}
		if ($ProfileType) {
			$url = "$url" + "profiletype=$ProfileType" + "&"
		}
		if ($Status) {
			$url = "$url" + "status=$Status" + "&"
		}
		if ($SearchText) {
			$url = "$url" + "searchtext=$SearchText" + "&"
		}
		
		$url = "$url" + "pagesize=9999"
		
		if ($url.Substring($url.Length - 1, 1) -eq "&") {
			$url = $url.Substring(0, $url.Length - 1)
		}
		
		if ($global:AWAuthorizationMechanism -eq "Certificate") {
			$global:AWAuthorizationHeaders.Authorization = "$(Get-CMSURLAuthorizationHeader -URL $Url -Certificate $global:AWAuthorizationCertificate)"
		}
		
		Write-Verbose -Message "[Get-AWProfile] URL: $url"
		Write-Verbose -Message "[Get-AWProfile] Query for profile"
		$resultFromRest = Invoke-RestMethod -Method Get -Uri $Url -Headers $global:AWAuthorizationHeaders -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
		Write-Verbose -Message "[Get-AWProfile] Query completed successfully"
		
		return $resultFromRest.Profiles
	}
}