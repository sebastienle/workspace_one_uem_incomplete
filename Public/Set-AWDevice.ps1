
function Set-AWDevice {
	# TO DO: WILL NEED TO VERIFY WHICH OF THESE PROPERTIES ARE MODIFIABLE!!!!! I'M CERTAIN THEY AREN'T ALL USER CHANGEABLE
	param (
		[Parameter(Mandatory)]
		$DeviceID,
		#$Udid,

		#$SerialNumber,

		#$MacAddress,

		#$Imei,

		#$EasId,

		$AssetNumber,
		$DeviceFriendlyName,
		#$LocationGroupId, 

		#$LocationGroupName, 

		#$UserId,

		#$Username,

		#$UserEmailAddress,

		$Ownership # LIST ALL AVAILABLE OPTIONS BESIDES C (Corporate Dedicated) and E (Employe)
		#$PlatformId,
		#$Platform,
		#$ModelId,
		#$Model,
		#$OperatingSystem,
		#$PhoneNumber,
		#$LastSeen,
		#$EnrollmentStatus,
		#$ComplianceStatus,
		#$CompromisedStatus,
		#$LastEnrolledOn,
		#$LastComplianceCheckOn,
		#$LastCompromiseCheckOn,
		#$ComplianceSummary,
		#$IsSupervised,
		#$DeviceMcc,
		#$IsRemoteManagementEnabled,
		#$DataEncryptionYN,
		#$AcLineStatus,
		#$VirtualMemory,
		#$OEMInfo,
		#$DeviceCapacity,
		#$AvailableDeviceCapacity,
		#$LastSystemSampleTime,
		#$IsDeviceDNDEnabled,
		#$IsDeviceLocatorEnabled,
		#$IsCloudBackupEnabled,
		#$IsActivationLockEnabled,
		#$IsNetworkTethered,
		#$BatteryLevel,
		#$IsRoaming,
		#$LastNetworkLANSampleTime,
		#$LastBluetoothSampleTime,
		#$SystemIntegrityProtectionEnabled,
		#$ProcessorArchitecture,
		#$UserApprovedEnrollment,
		#$EnrolledViaDEP,
		#$TotalPhysicalMemory,
		#$AvailablePhysicalMemory,
		#$OSBuildVersion,
		#$Hostname,
		#$LocalHostname,
		#$SecurityPatchDate,
		#$SystemUpdateReceivedTime,
		#$IsSecurityPatchUpdate,
		#$Uuid
	)
	Process {
		try {
			$url = "$global:AWHostname/api/mdm/devices/$DeviceID"
			
			$bodyContent = @{
			}
			
			if ($AssetNumber) {
				$bodyContent.add("AssetNumber", $AssetNumber)
			}
			if ($DeviceFriendlyName) {
				$bodyContent.add("DeviceFriendlyName", $DeviceFriendlyName)
			}
			if ($Ownership) {
				$bodyContent.add("Ownership", $Ownership)
			}
			
			$bodyContentJSON = ConvertTo-Json -InputObject $bodyContent
			
			Invoke-RestMethod -Method Put -Uri $Url -Headers $global:AWAuthorizationHeaders -Body $bodyContentJSON -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
			Write-Verbose -Message '[Set-AWDevice] Success updating the properties of the device'
			
			} catch {
			Write-Error -Exception $_.exception -ErrorAction Stop
		}
	}
}