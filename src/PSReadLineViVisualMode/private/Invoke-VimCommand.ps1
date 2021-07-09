function Invoke-VimCommand {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Command
    )

    for ($i = 0; $i -lt $Command.motionCount; $i++) {
        switch -CaseSensitive ($Command.motion) {
            'w' {[Microsoft.PowerShell.PSConsoleReadLine]::SelectNextWord()}
            'e' {[Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardWord()}
            '$' {[Microsoft.PowerShell.PSConsoleReadLine]::SelectLine()}
            'b' {[Microsoft.PowerShell.PSConsoleReadLine]::SelectBackwardWord()}
            {($_ -eq 'x') -or ($_ -eq 'd')} {
                [Microsoft.PowerShell.PSConsoleReadLine]::Copy()
                [Microsoft.PowerShell.PSConsoleReadLine]::DeleteChar()
                break loop
            }
            'l' {[Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar()}
            'h' {[Microsoft.PowerShell.PSConsoleReadLine]::SelectBackwardChar()}
            'y' {
                [Microsoft.PowerShell.PSConsoleReadLine]::Copy()
                break loop
            }
            'p' {
                [Microsoft.PowerShell.PSConsoleReadLine]::Paste()
                break loop
            }
            '^' {[Microsoft.PowerShell.PSConsoleReadLine]::SelectBackwardsLine()}
        }
    }
}