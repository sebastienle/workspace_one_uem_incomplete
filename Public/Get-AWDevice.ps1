
# Exportable Function
function Get-AWDevice {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false,
			 ValueFromPipelineByPropertyName = $true)]
		[string]$CompliantStatus,
		[Parameter(Mandatory = $false,
			 ValueFromPipelineByPropertyName = $true)]
		[string]$LastSeen,	#I believe this mean LastSeen is BEFORE the date provided
		[Parameter(Mandatory = $false,
			 ValueFromPipelineByPropertyName = $true)]
		[int]$LgId,
		#[Parameter(Mandatory = $false,
		#	 ValueFromPipelineByPropertyName = $true)]
		#[string]$Model, #The model search does not appear to work
		[Parameter(Mandatory = $false,
			 ValueFromPipelineByPropertyName = $true)]
		[string]$Ownership,
		[Parameter(Mandatory = $false,
			 ValueFromPipelineByPropertyName = $true)]
		[string]$Platform,
		[Parameter(Mandatory = $false,
			 ValueFromPipelineByPropertyName = $true)]
		[string]$SeenSince, #Seen since this date and ABOVE
		[Parameter(Mandatory = $false,
			 ValueFromPipelineByPropertyName = $true)]
		[string]$User
	)
	
	Process {
		Write-Verbose -Message "[Get-AWDevice] Process"
		
		$url = "$global:AWHostname/api/mdm/devices/search?"
		Write-Verbose -Message "[Get-AWDevice] Starting URL: $url"
		
		
		if ($CompliantStatus) {
			$url = "$url" + "compliantstatus=$CompliantStatus" + "&"
		}
		if ($LastSeen) {
			$url = "$url" + "lastseen=$LastSeen" + "&"
		}
		if ($LgId) {
			$url = "$url" + "lgid=$LgId" + "&"
		}
#		if ($Model) {
#			$url = "$url" + "model=$Model" + "&"
#		}
		if ($Ownership) {
			$url = "$url" + "ownership=$Ownership" + "&"
		}
		if ($Platform) {
			$url = "$url" + "platform=$Platform" + "&"
		}
		if ($SeenSince) {
			$url = "$url" + "seensince=$SeenSince" + "&"
		}
		if ($User) {
			$url = "$url" + "user=$User" + "&"
		}
		
		$url = "$url" + "pagesize=20000"
		
		if ($url.Substring($url.Length - 1, 1) -eq "&") {
			$url = $url.Substring(0, $url.Length - 1)
		}
		
		if ($global:AWAuthorizationMechanism -eq "Certificate") {
			$global:AWAuthorizationHeaders.Authorization = "$(Get-CMSURLAuthorizationHeader -URL $Url -Certificate $global:AWAuthorizationCertificate)"
		}
		
		Write-Verbose -Message "[Get-AWDevice] URL: $url"
		Write-Verbose -Message "[Get-AWDevice] Query for device"
		$resultFromRest = Invoke-RestMethod -Method Get -Uri $Url -Headers $global:AWAuthorizationHeaders -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
		Write-Verbose -Message "[Get-AWDevice] Query completed successfully"
		
		return $resultFromRest.Devices
	}
}