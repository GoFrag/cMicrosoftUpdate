function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("Notify","DownloadOnly","DownloadAndInstall","Disable","AllowUserConfig")]
		[System.String]
		$Mode
	)

	Write-Verbose "Get the Windows Server Update Service update mode"

    Try {
        $AUoption = Get-ItemPropertyValue -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name AUOptions -ErrorAction SilentlyContinue
    }
    Catch {
        $Auoption = "5"
    }

    Switch ($AUoption) {
        "2" {$ModeRef = "Notify"}
        "3" {$ModeRef = "DownloadOnly"}
        "4" {$ModeRef = "DownloadAndInstall"}
        "5" {$ModeRef = "AllowUserConfig"}
    }

    $returnValue = @{
		Mode = $ModeRef
	}

	$returnValue

}


function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("Notify","DownloadOnly","DownloadAndInstall","Disable","AllowUserConfig")]
		[System.String]
		$Mode
	)

	Write-Verbose "Set the Windows Server Update Service update mode to $Mode"

    Switch ($Mode) {
        "Notify" {$AUoption = "2"}
        "DownloadOnly" {$AUoption = "3"}
        "DownloadAndInstall" {$AUoption = "4"}
        "AllowUserConfig" {$AUoption = "5"}
    }

    Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name AUOptions -Value $AUoption -type dword -Force

}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("Notify","DownloadOnly","DownloadAndInstall","Disable","AllowUserConfig")]
		[System.String]
		$Mode
	)

	Write-Verbose "Test if the Windows Server Update Service update mode is set to $Mode"

    Try {
        $AUoption = Get-ItemPropertyValue -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name AUOptions -ErrorAction SilentlyContinue
    }
    Catch {
        $AUOption = ""
    }


    Switch ($AUoption) {
        "2" {$ModeRef = "Notify"}
        "3" {$ModeRef = "DownloadOnly"}
        "4" {$ModeRef = "DownloadAndInstall"}
        "5" {$ModeRef = "AllowUserConfig"}
    }

    if ($ModeRef -eq $Mode) {
        $Return = $true
    }
    else {
        $Return = $false
    }

    $Return
}


Export-ModuleMember -Function *-TargetResource

