#Exportable function
function Set-AWAuthentication {
	[CmdletBinding(DefaultParameterSetName = 'Certificate')]
	[OutputType([System.Collections.Hashtable])]
	Param (
		[Parameter(Mandatory = $true,
			 ValueFromPipelineByPropertyName = $true,
			 Position = 0)]
		[string]$Hostname,
		[Parameter(Mandatory = $true,
			 ValueFromPipelineByPropertyName)]
		[string]$APIKey,
		[Parameter(Mandatory,
			 ParameterSetName = 'Credential')]
		[System.Management.Automation.PSCredential]$Credential = [System.Management.Automation.PSCredential]::Empty,
		[Parameter(Mandatory,
			 ParameterSetName = 'UsernameAndPassword')]
		[string]$Username,
		[string]$Password,
		[Parameter(Mandatory,
			 ParameterSetName = 'Certificate')]
		[System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate
	)
	Begin {
		Write-Verbose -Message '[Set-AWAuthentication] Begin'
		#$Url = "https://$Hostname/API/v1/help"
		#$Url = "https://$Hostname/API/v1"
		$Url = "$global:AWHostname/api/mdm/devices/bulksettings"
	}
	Process {
		
		$global:AWAuthorizationDefined = $false
		$global:AWAuthorizationMechanism = ""
		$global:AWAuthorizationHeaders = @{}
		
		Switch ($PSCmdlet.ParameterSetName) {
			'UsernameAndPassword' {
				try {
					
					$concateUserInfo = $userName + ":" + $password
					$restUserName = Get-BasicUserForAuth ($concateUserInfo)
					
					$Headers = @{
						'Authorization' = "$restUserName"; 'aw-tenant-code' = "$APIKey"; 'Content-type' = 'application/json'; 'Accept' = 'application/json'
					}
					
					$global:AWAuthorizationDefined = $true
					$global:AWAuthorizationMechanism = "UsernameAndPassword"
					$global:AWAuthorizationHeaders = $Headers
					
					$null = Invoke-RestMethod -Method Get -Uri $Url -Headers $Headers -ErrorAction Stop -Proxy $global:AWProxyServer -ProxyUseDefaultCredentials
					Write-Verbose -Message '[Set-AWAuthentication] Success connecting to the AirWatch Instance'
					$Script:Hostname = $Hostname #set the Module Variable now
					$Script:Headers = $Headers #set the Module Headers now
					
				} catch {
					Write-Error -Exception $_.exception -ErrorAction Stop
				}
			}
			'Credential'
			{
				try {
					
					$encoding = [System.Text.Encoding]::UTF8.GetBytes($('{0}:{1}' -f $Credential.UserName, $Credential.GetNetworkCredential().Password))
					$EncodedUsernamePassword = [Convert]::ToBase64String($encoding)
					$Headers = @{
						'Authorization' = "Basic $($EncodedUsernamePassword)"; 'aw-tenant-code' = "$APIKey"; 'Content-type' = 'application/json'; 'Accept' = 'application/json'
					}
					
					$global:AWAuthorizationDefined = $true
					$global:AWAuthorizationMechanism = "Credential"
					$global:AWAuthorizationHeaders = $Headers
					
					$null = Invoke-RestMethod -Method Get -Uri $Url -Headers $Headers -ErrorAction Stop -Proxy $global:AWProxyServer -ProxyUseDefaultCredentials
					Write-Verbose -Message '[Set-AWAuthentication] Success connecting to the AirWatch Instance'
					$Script:Hostname = $Hostname #set the Module Variable now
					$Script:Headers = $Headers #set the Module Headers now
					
				} catch {
					Write-Error -Exception $_.exception -ErrorAction Stop
				}
			}
			'Certificate'
			{
				try {
					
					$Headers = @{
						'Authorization' = "$(Get-CMSURLAuthorizationHeader -URL $Url -Certificate $Certificate)"; 'aw-tenant-code' = "$APIKey"; 'Content-type' = 'application/json'
					}
					
					$global:AWAuthorizationDefined = $true
					$global:AWAuthorizationMechanism = "Certificate"
					$global:AWAuthorizationCertificate = $Certificate
					$global:AWAuthorizationHeaders = $Headers
					
					$null = Invoke-RestMethod -Method Get -Uri $Url -Headers $Headers -ErrorAction Stop -Proxy "$global:AWProxyServer" -ProxyUseDefaultCredentials
					Write-Verbose -Message '[Set-AWAuthentication] Success connecting to the AirWatch Instance'
					
				} catch {
					Write-Error -Exception $_.exception -ErrorAction Stop
				}
			}
		}
	}
	End {
		Write-Verbose -Message '[Connect-AirWatchInstance] END - Ending the Function'
	}
}
