

# Exportable Function
function Get-AWPicklist {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true,
			 ValueFromPipelineByPropertyName = $true)]
		[ValidateSet("DeviceCategories","DeviceTypes","OwnershipTypes")]
		[string]$Name
	)
	
	Process {
		Write-Verbose -Message "[Get-AWPicklist] Process"
		
		[boolean]$changedHeader = $false
		
		$url = "$global:AWHostname/api/mdm/picklists"
		
		switch ($Name.ToUpper().Trim()) {
			"DEVICECATEGORIES" {
				$url = "$global:AWHostname/api/mdm/picklists/devicecategories"
			}
			"DEVICETYPES" {
				$url = "$global:AWHostname/api/mdm/picklists/devicetypes"
			}
			"OWNERSHIPTYPES" {
				$url = "$global:AWHostname/api/mdm/picklists/ownershiptypes"
			}
		}
		
		if ($global:AWAuthorizationMechanism -eq "Certificate") {
			$global:AWAuthorizationHeaders.Authorization = "$(Get-CMSURLAuthorizationHeader -URL $Url -Certificate $global:AWAuthorizationCertificate)"
		}
		
		Write-Verbose -Message "[Get-AWPicklist] URL: $url"
		Write-Verbose -Message "[Get-AWPicklist] Query for picklist"
		$resultFromRest = Invoke-RestMethod -Method Get -Uri $Url -Headers $global:AWAuthorizationHeaders -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
		Write-Verbose -Message "[Get-AWPicklist] Query completed successfully"
		
		return $resultFromRest		
	}
}