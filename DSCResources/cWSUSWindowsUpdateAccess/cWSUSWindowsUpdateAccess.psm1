function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("False","True")]
		[System.String]
		$Enable
	)

    Write-Verbose "Get the status of Windows Server Update Service Windows Update Access."
	Try {
        if ((Get-ItemPropertyValue -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name DisableWindowsUpdateAccess -ErrorAction SilentlyContinue) -eq "1") {
            $Status = "True"
        }
        else {
            $Status = "False"
        }
    }
    Catch {
        $Status = "False"
    }

	$returnValue = @{
		Enable = $Status
	}

	$returnValue

}


function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("False","True")]
		[System.String]
		$Enable
	)
    if ($Enable -eq 'True') {
        Write-Verbose "Disable the access to Windows Server Update Service Windows Update Access."
        $value = '1' 
    }
    else {
        Write-Verbose "Enable the access to Windows Server Update Service Windows Update Access."
        $value = '0'
    }

    
	Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name DisableWindowsUpdateAccess -Value $value -type dword


}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("False","True")]
		[System.String]
		$Enable
	)

    Write-Verbose "Test if no access to Windows Server Update Service Windows Update Access is set to: $Enable"

	Try {
        $Status = Get-ItemPropertyValue -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate" -name DisableWindowsUpdateAccess -ErrorAction SilentlyContinue
    }
    Catch {
        $Status = ""
    }

    Switch ($enable) {
        'True' {
            if ($Status -eq 1) {
                $Return = $true
            }
            else {
                $Return = $false
            }
        }

        'False' {
            if ($Status -eq 0) {
                $Return = $true
            }
            else {
                $Return = $false
            }
        }
    }
    
    $Return
}


Export-ModuleMember -Function *-TargetResource

