function Invoke-UserInputGenerator {
    [CmdletBinding()]
    param (
        # Amount of samples to create
        [Parameter(Mandatory = $true)]
        [int]$Samples
    )

    $Generated = @()

    for ($i = 0; $i -lt $Samples; $i++) {
        $randomMotion = -join @(
            Get-Random -InputObject @(1..999; "") -Count 1
            "a".."z" | Get-Random -Count 1
        )

        if ($randomMotion.Length -eq 1) {
            $Generated += @{ UserInput = $randomMotion; Expected = [PSCustomObject]@{motionCount = 1; motion = $randomMotion} }
        } else {
            $parsedInput = $randomMotion | Select-String "^(\D)|(\d+)(\D)$"
            $Generated += @{
                UserInput = $randomMotion
                Expected =
                    [PSCustomObject]@{
                        motionCount = $parsedInput.Matches.Groups[2].Value
                        motion = $parsedInput.Matches.Groups[3].Value
                    }
            }
        }
    }

    $Generated
}