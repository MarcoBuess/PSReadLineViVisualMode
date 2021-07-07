function Read-Input {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.ConsoleKeyInfo[]]$UserInput
    )

    Write-Verbose -Message "Key pressed [$($UserInput[$UserInput.Length - 1].Key)]"

    switch ($UserInput[$UserInput.Length - 1]) {
        {[char]::IsDigit($_.KeyChar)} { Read-Input -UserInput ($UserInput += $([Console]::ReadKey($true))) }
        {$_.Key -eq [ConsoleKey]::Escape} { $null }
        Default {$UserInput.KeyChar -join ''}
    }
}