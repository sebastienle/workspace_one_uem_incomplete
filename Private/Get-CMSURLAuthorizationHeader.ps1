

function Get-CMSURLAuthorizationHeader {
	[CmdletBinding()]
	[OutputType([string])]
	Param
	(
		# Input the URL to be
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0)]
		[uri]$URL,
		# Specify the Certificate to be used 

		[Parameter(Mandatory = $true,
				   ValueFromPipeline)]
		[System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate
	)
	
	Begin {
		Write-Verbose -Message '[Get-CMSURLAuthorizationHeader] Starting Function'
		
	}
	Process {
		TRY {
			#Add the assembly
			Add-Type -AssemblyName System.Security
			
			#Get the Absolute Path of the URL encoded in UTF8
			$bytes = [System.Text.Encoding]::UTF8.GetBytes(($Url.AbsolutePath))
			
			#Open Memory Stream passing the encoded bytes
			$MemStream = New-Object -TypeName System.Security.Cryptography.Pkcs.ContentInfo -ArgumentList ( ,$bytes) -ErrorAction Stop
			
			#Create the Signed CMS Object providing the ContentInfo (from Above) and True specifying that this is for a detached signature
			$SignedCMS = New-Object -TypeName System.Security.Cryptography.Pkcs.SignedCms -ArgumentList $MemStream, $true -ErrorAction Stop
			
			#Create an instance of the CMSigner class - this class object provide signing functionality
			$CMSigner = New-Object -TypeName System.Security.Cryptography.Pkcs.CmsSigner -ArgumentList $Certificate -Property @{
				IncludeOption = [System.Security.Cryptography.X509Certificates.X509IncludeOption]::EndCertOnly
			} -ErrorAction Stop
			
			#Add the current time as one of the signing attribute
			$null = $CMSigner.SignedAttributes.Add((New-Object -TypeName System.Security.Cryptography.Pkcs.Pkcs9SigningTime))
			
			#Compute the Signatur
			$SignedCMS.ComputeSignature($CMSigner)
			
			#As per the documentation the authorization header needs to be in the format 'CMSURL `1 <Signed Content>'
			#One can change this value as per the format the Vendor's REST API documentation wants.
			$CMSHeader = '{0}{1}{2}' -f 'CMSURL', '`1 ', $([System.Convert]::ToBase64String(($SignedCMS.Encode())))
			Write-Output -InputObject $CMSHeader
		} Catch {
			Write-Error -Exception $_.exception -ErrorAction stop
		}
	}
	End {
		Write-Verbose -Message '[Get-CMSURLAuthorizationHeader] Ending Function'
	}
}