function Test-Input {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$UserInput
    )

    $parsedInput = $UserInput | Select-String "^(\D)|(\d+)(\D)$"

    Write-Verbose -Message "Parsed input [$parsedInput]"

    switch ($parsedInput.Matches.Groups[1].Success) {
        True {
            [PSCustomObject]@{
                motionCount = 1
                motion      = $parsedInput.Matches.Groups[1].Value
            }
        }
        Default {
            [PSCustomObject]@{
                motionCount = $parsedInput.Matches.Groups[2].Value
                motion      = $parsedInput.Matches.Groups[3].Value
            }
        }
    }
}