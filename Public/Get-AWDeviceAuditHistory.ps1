
function Get-AWDeviceAuditHistory {
	param (
		[Parameter(Mandatory = $true)]
		$OrganizationGroupId,
		$SerialNumber,
		$Status,
		$Startdate,
		$Enddate,
		#$Page,

		#$Pagesize,

		$SortOrder
	)
	
	#From the doc
	#The query parameters startdate and enddate accepts the below DateTime formats : 
	#yyyy/MM/dd, yyyy-MM-dd, MM/dd/yyyy, MM-dd-yyyy, yyyy/MM/dd HH:mm:ss.fff, yyyy-MM-dd HH:mm:ss.fff, MM/dd/yyyy HH:mm:ss.fff, MM-dd-yyyy HH:mm:ss.fff,
	#yyyy/MM/ddTHH:mm:ss.fff, yyyy-MM-ddTHH:mm:ss.fff, MM/dd/yyyyTHH:mm:ss.fff, MM-dd-yyyyTHH:mm:ss.fff, yyyy-MM-dd HH-mm-ss-tt, yyyy-MM-ddTHH-mm-ss-tt.
	
	Process {
		try {
			$url = "$global:AWHostname/api/mdm/ogs/$OrganizationGroupId/devices/audit"
			
			if (($SerialNumber) -or ($Status) -or ($Startdate) -or ($Enddate) -or ($SortOrder)) {
				$url = "$url" + "?"
			}
			if ($SerialNumber) {
				$url = "$url" + "serialnumber=$SerialNumber"
			}
			if ($Status) {
				$url = "$url" + "status=$Status"
			}
			if ($Startdate) {
				$url = "$url" + "startdate=$Startdate"
			}
			if ($Enddate) {
				$url = "$url" + "enddate=$Enddate"
			}
			if ($SortOrder) {
				$url = "$url" + "sortorder=$SortOrder"
			}
			
			$resultFromRest = Invoke-RestMethod -Method Get -Uri $Url -Headers $global:AWAuthorizationHeaders -Body $bodyContentJSON -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
			Write-Verbose -Message '[Get-AWDeviceAuditHistory] Success getting audit information'
			
			return $resultFromRest.DevicesCount
		} catch {
			# Note: This returns an error when the query returns no result - this should not be
			# # Dig into the exception to get the Response details.
			# Note that value__ is not a typo.
			#Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__
			#Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
			Write-Error -Exception $_.exception -ErrorAction Stop
		}
	}
	
}