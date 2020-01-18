
# Internal Function
function Get-BasicUserForAuth {
	
	Param ([string]$func_username)
	
	$userNameWithPassword = $func_username
	$encoding = [System.Text.Encoding]::ASCII.GetBytes($userNameWithPassword)
	$encodedString = [Convert]::ToBase64String($encoding)
	
	Return "Basic " + $encodedString
}